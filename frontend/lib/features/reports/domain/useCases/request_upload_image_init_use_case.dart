import 'package:frontend/features/reports/data/models/upload_image_init_model.dart';
import 'package:frontend/features/reports/domain/repositories/report_repository.dart';

class RequestUploadImageInitUseCase {
  final ReportRepository repository;

  RequestUploadImageInitUseCase({required this.repository});

  Future<UploadImageInitModel> call({
    required String fileName,
    required String contentType,
  }) async {
    return await repository.getUploadImageInit(fileName: fileName, contentType: contentType);
  }
}
