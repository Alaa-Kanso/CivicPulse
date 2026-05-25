import 'package:flutter/material.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/reports/presentation/screens/Citizen/components/citizen_page_component.dart';

class DetailsMediaPreview extends StatelessWidget {
  final String imageUrl;

  const DetailsMediaPreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withOpacity(0.4),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.surfaceLight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.textMuted,
                  size: 48,
                ),
                SizedBox(height: 8.0),
                Text(
                  "No attachment provided",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: AppColors.surfaceLight,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailsHeaderCard extends StatelessWidget {
  final String reportTypeName;
  final String status;
  final DateTime createdAtUtc;

  const DetailsHeaderCard({
    super.key,
    required this.reportTypeName,
    required this.status,
    required this.createdAtUtc,
  });

  String _formatDate(DateTime date) {
    final months = [
      "January", "February", "March", "April", "May", "June", 
      "July", "August", "September", "October", "November", "December"
    ];
    final localDate = date.toLocal();
    final hour = localDate.hour == 0 ? 12 : (localDate.hour > 12 ? localDate.hour - 12 : localDate.hour);
    final period = localDate.hour >= 12 ? "PM" : "AM";
    final minute = localDate.minute.toString().padLeft(2, '0');
    return "${months[localDate.month - 1]} ${localDate.day}, ${localDate.year} at $hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.border.withOpacity(0.4),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  reportTypeName,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              StatusPill(status: status),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 14.0,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6.0),
              Expanded(
                child: Text(
                  _formatDate(createdAtUtc),
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailsLocationCard extends StatelessWidget {
  final String location;
  final String? addressDetails;

  const DetailsLocationCard({
    super.key,
    required this.location,
    this.addressDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.border.withOpacity(0.4),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "LOCATION DETAILS",
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 18.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (addressDetails != null && addressDetails!.isNotEmpty) ...[
                      const SizedBox(height: 6.0),
                      Text(
                        addressDetails!,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailsDescriptionCard extends StatelessWidget {
  final String description;

  const DetailsDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: AppColors.border.withOpacity(0.4),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "REPORT DESCRIPTION",
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14.0,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
