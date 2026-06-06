import 'package:CivicPulse/core/di/injection_container.dart';
import 'package:CivicPulse/features/abuse_report/data/dataSources/abuse_report_remote_data_source.dart';
import 'package:CivicPulse/features/abuse_report/data/repositories_impl/abuse_report_repository_impl.dart';
import 'package:CivicPulse/features/abuse_report/domain/repositories/abuse_report_repository.dart';
import 'package:CivicPulse/features/abuse_report/domain/useCases/block_reported_user_use_case.dart';
import 'package:CivicPulse/features/abuse_report/domain/useCases/dismiss_report_use_case.dart';
import 'package:CivicPulse/features/abuse_report/domain/useCases/get_abuse_report_details_use_case.dart';
import 'package:CivicPulse/features/abuse_report/domain/useCases/get_abuse_report_use_case.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_actions_cubit.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_cubit.dart';
import 'package:CivicPulse/features/abuse_report/presentation/cubit/abuse_report_details_cubit.dart';

Future<void> abuseReportInit() async {
  //Data source

  sl.registerLazySingleton<AbuseReportRemoteDataSource>(
    () => AbuseReportRemoteDataSource(apiClient: sl()),
  );

  //Repository
  sl.registerLazySingleton<AbuseReportRepository>(
    () => AbuseReportRepositoryImpl(abuseReportRemoteDataSource: sl()),
  );

  //useCase
  sl.registerLazySingleton(
    () => GetAbuseReportUseCase(abuseReportRepository: sl()),
  );
  sl.registerLazySingleton(
    () => GetAbuseReportDetailsUseCase(abuseReportRepository: sl()),
  );
  sl.registerLazySingleton(
    () => BlockReportedUserUseCase(abuseReportRepository: sl()),
  );
  sl.registerLazySingleton(
    () => DismissReportUseCase(abuseReportRepository: sl()),
  );

  //cubit
  sl.registerFactory(() => AbuseReportCubit(getAbuseReportUseCase: sl()));
  sl.registerFactory(
    () => AbuseReportDetailsCubit(getAbuseReportDetailsUseCase: sl()),
  );
  sl.registerFactory(
    () => AbuseReportActionsCubit(
      dismissReportUseCase: sl(),
      blockReportedUserUseCase: sl(),
    ),
  );
}
