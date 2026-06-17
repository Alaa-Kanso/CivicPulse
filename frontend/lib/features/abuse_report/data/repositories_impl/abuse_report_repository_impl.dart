import 'package:CivicPulse/features/abuse_report/data/dataSources/abuse_report_remote_data_source.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report_details.dart';
import 'package:CivicPulse/features/abuse_report/domain/repositories/abuse_report_repository.dart';

class AbuseReportRepositoryImpl extends AbuseReportRepository {
  final AbuseReportRemoteDataSource abuseReportRemoteDataSource;

  AbuseReportRepositoryImpl({required this.abuseReportRemoteDataSource});

  @override
  Future<void> blockReportedUser({required String id}) async {
    await abuseReportRemoteDataSource.blockReportedUser(id: id);
  }

  @override
  Future<void> dismissReport({required String id}) async {
    await abuseReportRemoteDataSource.dismissReport(id: id);
  }

  @override
  Future<AbuseReportDetails> getAbuseReportDetails({required String id}) async {
    return await abuseReportRemoteDataSource.getAbuseReportDetails(id: id);
  }

  @override
  Future<List<AbuseReport>> getAbuseReports() async {
    return await abuseReportRemoteDataSource.getAbuseReports();
  }
}
