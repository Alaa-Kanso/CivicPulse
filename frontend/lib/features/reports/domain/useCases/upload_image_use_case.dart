import 'dart:typed_data';

import 'package:CivicPulse/features/reports/domain/repositories/report_repository.dart';

class UploadImageUseCase {
  final ReportRepository repository;

  UploadImageUseCase({required this.repository});

  Future<void> call({
    required String imageKey,
    required String uploadUrl,
    required String fileExtension,
    required Uint8List fileBytes,
  }) async {
    await repository.uploadImageToSupabase(
      imageKey: imageKey,
      uploadUrl: uploadUrl,
      fileBytes: fileBytes,
      fileExtension: fileExtension,
    );
  }
}
