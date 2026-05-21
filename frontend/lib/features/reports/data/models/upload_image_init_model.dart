class UploadImageInitModel {
  final String imageKey;
  final String uploadUrl;

  UploadImageInitModel({required this.imageKey, required this.uploadUrl});

  factory UploadImageInitModel.fromJson(Map<String, dynamic> json) {
    return UploadImageInitModel(
      imageKey: json["imageKey"],
      uploadUrl: json["uploadUrl"],
    );
  }
}
