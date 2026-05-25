import 'package:flutter/material.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';

class AdminReroutingReports extends StatefulWidget {
  const AdminReroutingReports({super.key});

  @override
  State<AdminReroutingReports> createState() => _AdminReroutingReportsState();
}

class _AdminReroutingReportsState extends State<AdminReroutingReports> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            BoldText(
              text: "Manual Routing Queue",
              size: 30.0,
              color: AppColors.textPrimary,
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 1,
              ),
              itemBuilder: (context, index) {
                return Container(
                  child: NormalText(text: "container", size: 20.0, color: AppColors.textPrimary),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
