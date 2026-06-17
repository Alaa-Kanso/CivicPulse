import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/features/reports/data/models/report_type_model.dart';
import 'package:CivicPulse/features/reports/data/models/upload_image_init_model.dart';
import 'package:CivicPulse/features/reports/domain/useCases/create_report_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/geocoding_location_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/get_category_types_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/request_upload_image_init_use_case.dart';
import 'package:CivicPulse/features/reports/domain/useCases/upload_image_use_case.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/create_report_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class CreateReportCubit extends Cubit<CreateReportState> {
  CreateReportCubit({
    required this.getCategoryTypesUseCase,
    required this.geocodingLocationUseCase,
    required this.requestUploadImageInitUseCase,
    required this.uploadImageUseCase,
    required this.createReportUseCase,
  }) : super(CreateReportInitial());

  final GetCategoryTypesUseCase getCategoryTypesUseCase;
  final GeocodingLocationUseCase geocodingLocationUseCase;
  final RequestUploadImageInitUseCase requestUploadImageInitUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final CreateReportUseCase createReportUseCase;

  List<ReportTypeModel> reportCategoryTypes = [];
  ReportTypeModel? currentReportType;
  XFile? pickedImage;
  double? latitude;
  double? longitude;

  Future<void> getCategoryTypes() async {
    try {
      emit(CreateReportLoading());
      reportCategoryTypes = await getCategoryTypesUseCase.call();
      emit(CategoryTypesLoaded(reportCategoryTypes: reportCategoryTypes));
      await handlePermissions();
    } catch (e) {
      emit(CategoryTypesError(error: e.toString()));
    }
  }

  Future<void> handlePermissions() async {
    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }

    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }
  }

  void setCategoryType({required ReportTypeModel model}) {
    currentReportType = model;
    emit(ChooseCategorySuccess(reportTypeModel: model));
  }

  Future<void> setMarkLocation({
    required double latitude,
    required double longitude,
  }) async {
    String placement = await geocodingLocationUseCase.call(
      latitude: latitude,
      longitude: longitude,
    );
    this.longitude = longitude;
    this.latitude = latitude;
    emit(
      MarkLocationSuccess(
        latitude: latitude,
        longitude: longitude,
        placement: placement,
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    if (source == ImageSource.camera && !await Permission.camera.isGranted) {
      await Permission.camera.request();
      return;
    }
    pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1280,
      maxHeight: 1280,
    );
    if (pickedImage == null) {
      emit(PickImageSuccess(file: null));
      return;
    }
    emit(PickImageSuccess(file: File(pickedImage!.path)));
  }

  void removeImage() {
    pickedImage = null;
    emit(PickImageSuccess(file: null));
  }

  String _getFileExtension() {
    final extension = p
        .extension(pickedImage!.name)
        .replaceFirst('.', '')
        .toLowerCase();
    String contentType = "Unsupported Image type";
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        contentType = 'image/jpeg';

      case 'png':
        contentType = 'image/png';

      case 'webp':
        contentType = 'image/webp';

      default:
        throw Exception('Unsupported image type');
    }
    return contentType;
  }

  Future<UploadImageInitModel> _getUploadImageInit({
    required String fileExtension,
  }) async {
    final nameWithoutExtension = p.basenameWithoutExtension(pickedImage!.name);

    return await requestUploadImageInitUseCase.call(
      fileName: nameWithoutExtension,
      contentType: fileExtension,
    );
  }

  Future<void> uploadImageToSupabase({
    required String imageKey,
    required String uploadUrl,
    required String fileExtension,
    required Uint8List fileBytes,
  }) async {
    await uploadImageUseCase.call(
      imageKey: imageKey,
      uploadUrl: uploadUrl,
      fileBytes: fileBytes,
      fileExtension: fileExtension,
    );
  }

  Future<void> submitReport({
    required String description,
    required String addressDetails,
  }) async {
    emit(SubmitReportLoading());
    String errorMessage = "";
    if (currentReportType == null) {
      errorMessage += "Choose a category\n";
    }
    if (latitude == null || longitude == null) {
      errorMessage += "Choose location\n";
    }
    if (pickedImage == null) {
      errorMessage += "Upload an image\n";
    }
    if (description.isEmpty) {
      errorMessage += "Description is Required";
    }
    if (errorMessage.isNotEmpty) {
      emit(CreateReportFailure(error: errorMessage));
      return;
    }
    try {
      String fileExtension = _getFileExtension();
      final imageInit = await _getUploadImageInit(fileExtension: fileExtension);
      final Uint8List fileBytes = await pickedImage!.readAsBytes();
      await uploadImageToSupabase(
        imageKey: imageInit.imageKey,
        uploadUrl: imageInit.uploadUrl,
        fileBytes: fileBytes,
        fileExtension: fileExtension,
      );
      await createReportUseCase.call(
        reportTypeId: currentReportType!.id,
        latitude: latitude!,
        longitude: longitude!,
        imageKey: imageInit.imageKey,
        description: description,
        addressDetails: addressDetails,
      );
      emit(CreateReportSuccess());
    } catch (e) {
      emit(CreateReportFailure(error: e.toString()));
    }
  }
}
