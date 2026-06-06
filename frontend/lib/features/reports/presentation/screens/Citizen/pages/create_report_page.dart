import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/create_report_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/create_report_state.dart';
import 'package:CivicPulse/features/reports/presentation/screens/Citizen/components/create_report_page_component.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressDetailsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CreateReportCubit>().getCategoryTypes();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    addressDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateReportCubit, CreateReportState>(
      listener: (BuildContext context, CreateReportState state) {
        if (state is CreateReportFailure) {
          ErrorCitizenDialog.show(context);
        }
        if (state is CreateReportSuccess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            "Create Report",
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: BlocBuilder<CreateReportCubit, CreateReportState>(
            buildWhen: (previous, current) =>
                current is CreateReportLoading ||
                current is CategoryTypesLoaded,
            builder: (BuildContext context, CreateReportState state) {
              if (state is CreateReportLoading) {
                return CreateReportInit();
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CategorySection(),
                      const SizedBox(height: 18.0),
                      const LocationSection(),
                      const SizedBox(height: 18.0),
                      AddressDetailsSection(
                        addressDetailsController: addressDetailsController,
                      ),
                      const SizedBox(height: 18.0),
                      const UploadImageSection(),
                      const SizedBox(height: 18.0),
                      DescriptionSection(
                        descriptionController: descriptionController,
                      ),
                      const SizedBox(height: 24.0),
                      SubmitButtonSection(
                        descriptionController: descriptionController,
                        addressDetails: addressDetailsController,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
