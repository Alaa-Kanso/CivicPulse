import 'package:flutter/material.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/reports/domain/entities/report_details.dart';
import 'package:frontend/features/reports/presentation/screens/Citizen/components/details_page_component.dart';

class DetailsPage extends StatelessWidget {
  final ReportDetails report;

  const DetailsPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Report Details",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
            size: 20.0,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailsMediaPreview(imageUrl: "${report.imageUrl}"),
              const SizedBox(height: 24.0),
              DetailsHeaderCard(
                reportTypeName: report.reportTypeName,
                status: report.status,
                createdAtUtc: report.createdAtUtc,
              ),
              const SizedBox(height: 20.0),
              DetailsLocationCard(
                location: report.location,
                addressDetails: report.addressDetails,
              ),
              const SizedBox(height: 20.0),
              DetailsDescriptionCard(description: report.description),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
