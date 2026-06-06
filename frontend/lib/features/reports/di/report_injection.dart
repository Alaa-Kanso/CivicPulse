import 'package:frontend/core/di/injection_container.dart';
import 'package:frontend/features/reports/data/dataSources/report_remote_data_source.dart';
import 'package:frontend/features/reports/data/repositories_impl/report_repository_impl.dart';
import 'package:frontend/features/reports/domain/repositories/report_repository.dart';
import 'package:frontend/features/reports/domain/useCases/change_status_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/create_report_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/delete_report_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/geocoding_location_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/get_admin_rerouting_reports_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/get_category_types_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/get_my_reports_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/mark_as_escalate_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/mark_as_spam_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/operator_report_details_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/operator_reports_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/request_upload_image_init_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/reroute_municipality_use_case.dart';
import 'package:frontend/features/reports/domain/useCases/upload_image_use_case.dart';
import 'package:frontend/features/reports/presentation/cubit/create_report_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/my_reports_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_manager_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_report_details_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/operator_reports_cubit.dart';
import 'package:frontend/features/reports/presentation/cubit/rerouting_report_cubit.dart';

Future<void> reportInit() async {
  //Data source

  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSource(apiClient: sl()),
  );

  //Repository
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(reportRemoteDataSource: sl()),
  );

  //useCase
  sl.registerLazySingleton(() => GetMyReportsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoryTypesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GeocodingLocationUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => RequestUploadImageInitUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => UploadImageUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateReportUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => GetAdminReroutingReportsUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => DeleteReportUseCase(reportRepository: sl()));
  sl.registerLazySingleton(
    () => RerouteMunicipalityUseCase(reportRepository: sl()),
  );
  sl.registerLazySingleton(
    () => OperatorReportsUseCase(reportRepository: sl()),
  );
  sl.registerLazySingleton(
    () => OperatorReportDetailsUseCase(reportRepository: sl()),
  );
  sl.registerLazySingleton(() => MarkAsSpamUseCase(reportRepository: sl()));
  sl.registerLazySingleton(() => MarkAsEscalateUseCase(reportRepository: sl()));
  sl.registerLazySingleton(() => ChangeStatusUseCase(reportRepository: sl()));

  //cubit
  sl.registerFactory(
    () => MyReportsCubit(
      getMyReportsUseCase: sl(),
      geocodingLocationUseCase: sl(),
      getCategoryTypesUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => CreateReportCubit(
      getCategoryTypesUseCase: sl(),
      geocodingLocationUseCase: sl(),
      requestUploadImageInitUseCase: sl(),
      uploadImageUseCase: sl(),
      createReportUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ReroutingReportCubit(
      getAdminReroutingReportsUseCase: sl(),
      deleteReportUseCase: sl(),
      rerouteMunicipalityUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OperatorReportsCubit(
      getCategoryTypesUseCase: sl(),
      operatorReportsUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OperatorReportDetailsCubit(
      operatorReportDetailsUseCase: sl(),
      geocodingLocationUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OperatorManagerCubit(
      markAsSpamUseCase: sl(),
      markAsEscalateUseCase: sl(),
      changeStatusUseCase: sl(),
    ),
  );
}
