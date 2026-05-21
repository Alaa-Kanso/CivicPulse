class RefreshResponseModel {
  final String accessToken;
  final String refreshToken;

  RefreshResponseModel({required this.accessToken, required this.refreshToken});

  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshResponseModel(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}
