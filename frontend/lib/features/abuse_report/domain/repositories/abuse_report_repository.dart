import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report.dart';
import 'package:CivicPulse/features/abuse_report/domain/entities/abuse_report_details.dart';

abstract class AbuseReportRepository {
  Future<List<AbuseReport>> getAbuseReports();

  Future<AbuseReportDetails> getAbuseReportDetails({required String id});

  Future<void> blockReportedUser({required String id});

  Future<void> dismissReport({required String id});
}
