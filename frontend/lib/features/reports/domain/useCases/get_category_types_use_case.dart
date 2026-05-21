import 'package:frontend/features/reports/data/models/report_type_model.dart';
import 'package:frontend/features/reports/domain/repositories/report_repository.dart';

class GetCategoryTypesUseCase {
  final ReportRepository repository;

  GetCategoryTypesUseCase({required this.repository});
  Future<List<ReportTypeModel>> call() async {
    return await repository.getCategoryTypes();
  }
}