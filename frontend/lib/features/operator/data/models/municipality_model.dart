import 'package:CivicPulse/features/operator/domain/entities/municipality.dart';

class MunicipalityModel extends Municipality {
  const MunicipalityModel({
    required super.id,
    required super.name,
    required super.pcode,
  });

  factory MunicipalityModel.fromJson(Map<String, dynamic> json) {
    return MunicipalityModel(
      id: (json['id'] as num).toInt(),
      name: json['adm3Name'] as String,
      pcode: json['adm3Pcode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'adm3Name': name, 'adm3Pcode': pcode};
  }

  static List<MunicipalityModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => MunicipalityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
