import 'package:CivicPulse/features/reports/domain/entities/report_type.dart';

class ReportTypeModel extends ReportType {
  ReportTypeModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory ReportTypeModel.fromJson(Map<String, dynamic> json) {
    return ReportTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
