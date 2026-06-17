import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CivicPulse/config/settings/app_colors.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/create_report_cubit.dart';
import 'package:CivicPulse/features/reports/presentation/cubit/create_report_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateReportCubit, CreateReportState>(
      builder: (BuildContext context, CreateReportState state) {
        final isLoading = state is SubmitReportLoading;
        return InkWell(
          onTap: isLoading
              ? null
              : () {
                  CategoryDialog.show(context);
                },
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: AppColors.border.withOpacity(0.4),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.only(right: 16.0),
                  child: const Icon(
                    Icons.dangerous_rounded,
                    color: AppColors.primary,
                    size: 26.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ISSUE CATEGORY",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      BlocBuilder<CreateReportCubit, CreateReportState>(
                        buildWhen: (previous, current) =>
                            current is CategoryTypesLoaded ||
                            current is ChooseCategorySuccess,
                        builder:
                            (BuildContext context, CreateReportState state) {
                              String text = "Choose category";
                              if (state is ChooseCategorySuccess) {
                                text = state.reportTypeModel.name;
                              }
                              return Text(
                                text,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: state is ChooseCategorySuccess
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary.withOpacity(
                                          0.7,
                                        ),
                                ),
                              );
                            },
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.0,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategoryDialog {
  static void show(BuildContext context) {
    final cubit = context.read<CreateReportCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text(
              "Select Category",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: BlocBuilder<CreateReportCubit, CreateReportState>(
                buildWhen: (previous, current) =>
                    current is CategoryTypesLoaded,
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: cubit.reportCategoryTypes.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppColors.border.withOpacity(0.5),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = cubit.reportCategoryTypes[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.0,
                          color: AppColors.textSecondary,
                        ),
                        onTap: () {
                          cubit.setCategoryType(model: item);
                          Navigator.pop(dialogContext);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CreateReportInit extends StatelessWidget {
  const CreateReportInit({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            strokeWidth: 3.0,
          ),
          SizedBox(height: 16.0),
          Text(
            "Initializing report form...",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateReportCubit, CreateReportState>(
      builder: (BuildContext context, CreateReportState state) {
        bool absorbing = state is SubmitReportLoading;
        return AbsorbPointer(
          absorbing: absorbing,
          child: BlocBuilder<CreateReportCubit, CreateReportState>(
            buildWhen: (previous, current) =>
                current is CreateReportInitial ||
                current is MarkLocationSuccess,
            builder: (BuildContext context, CreateReportState state) {
              double? latitude;
              double? longitude;
              String? placement;
              if (state is MarkLocationSuccess) {
                latitude = state.latitude;
                longitude = state.longitude;
                placement = state.placement;
              }
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.border.withOpacity(0.4),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                      child: SizedBox(
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(33.8547, 35.8623), // Lebanon
                            zoom: 8.2,
                          ),
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                          cameraTargetBounds: CameraTargetBounds(
                            LatLngBounds(
                              southwest: const LatLng(33.055, 35.095),
                              northeast: const LatLng(34.691, 36.625),
                            ),
                          ),
                          markers: (longitude == null || latitude == null)
                              ? {}
                              : {
                                  Marker(
                                    markerId: const MarkerId("selected"),
                                    position: LatLng(latitude, longitude),
                                  ),
                                },
                          minMaxZoomPreference: const MinMaxZoomPreference(
                            9,
                            23,
                          ),
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          mapToolbarEnabled: false,
                          onTap: (LatLng position) {
                            context.read<CreateReportCubit>().setMarkLocation(
                              latitude: position.latitude,
                              longitude: position.longitude,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
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
                              size: 20.0,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "SELECTED LOCATION",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  placement ?? "Tap map to mark location",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: placement != null
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary.withOpacity(
                                            0.7,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class UploadImageSection extends StatelessWidget {
  const UploadImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attachment (Required)",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border.withOpacity(0.6)),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<CreateReportCubit, CreateReportState>(
            buildWhen: (previous, current) =>
                current is CreateReportInitial || current is PickImageSuccess,
            builder: (context, state) {
              if (state is PickImageSuccess && state.file != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.file(state.file!, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child:
                              BlocBuilder<CreateReportCubit, CreateReportState>(
                                builder:
                                    (
                                      BuildContext context,
                                      CreateReportState state,
                                    ) {
                                      return IconButton(
                                        onPressed:
                                            (state is SubmitReportLoading)
                                            ? null
                                            : context
                                                  .read<CreateReportCubit>()
                                                  .removeImage,
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  const SizedBox(height: 12.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.primary.withOpacity(0.06),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: const Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.primary,
                      size: 32.0,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  const Text(
                    "Upload photos of the issue to help us resolve it faster.",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      UploadActionContainer(
                        color: AppColors.primary,
                        text: "Take Photo",
                        iconData: Icons.camera_alt_rounded,
                        onTap: () async {
                          await context.read<CreateReportCubit>().pickImage(
                            ImageSource.camera,
                          );
                        },
                      ),
                      const SizedBox(width: 12.0),
                      UploadActionContainer(
                        color: Colors.black87,
                        text: "Gallery",
                        iconData: Icons.photo_library_rounded,
                        onTap: () async {
                          await context.read<CreateReportCubit>().pickImage(
                            ImageSource.gallery,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class UploadActionContainer extends StatelessWidget {
  const UploadActionContainer({
    super.key,
    required this.color,
    required this.text,
    required this.iconData,
    required this.onTap,
  });

  final Color color;
  final String text;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CreateReportCubit, CreateReportState>(
        builder: (BuildContext context, CreateReportState state) {
          VoidCallback? fun = onTap;
          if (state is SubmitReportLoading) {
            fun = null;
          }
          return GestureDetector(
            onTap: fun,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: AppColors.border.withOpacity(0.4),
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconData, color: color, size: 20.0),
                  const SizedBox(width: 6.0),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key, required this.descriptionController});

  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8.0),
        BlocBuilder<CreateReportCubit, CreateReportState>(
          builder: (BuildContext context, CreateReportState state) {
            bool enabled = state is! SubmitReportLoading;
            return TextField(
              enabled: enabled,
              controller: descriptionController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surfaceLight,
                hintText:
                    "Describe the issue in detail (e.g., size of the pothole, any safety hazards)...",
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.5),
                  fontSize: 14.0,
                ),
                contentPadding: const EdgeInsets.all(16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: AppColors.border.withOpacity(0.4),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 5,
              maxLength: 2000,
              style: const TextStyle(
                fontSize: 14.0,
                color: AppColors.textPrimary,
              ),
            );
          },
        ),
      ],
    );
  }
}

class ErrorCitizenDialog {
  static void show(BuildContext context) {
    final cubit = context.read<CreateReportCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: cubit,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Row(
              children: const [
                Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "Error",
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: BlocBuilder<CreateReportCubit, CreateReportState>(
              buildWhen: (previous, current) => current is CreateReportFailure,
              builder: (context, state) {
                String error = "Invalid error!";
                if (state is CreateReportFailure) {
                  error = state.error;
                }
                return Text(
                  error,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  "Close",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddressDetailsSection extends StatelessWidget {
  const AddressDetailsSection({
    super.key,
    required this.addressDetailsController,
  });

  final TextEditingController addressDetailsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Address Details",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8.0),
        BlocBuilder<CreateReportCubit, CreateReportState>(
          builder: (BuildContext context, CreateReportState state) {
            bool enabled = state is! SubmitReportLoading;
            return TextField(
              enabled: enabled,
              controller: addressDetailsController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surfaceLight,
                hintText: "Provide additional address information (optional)",
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.5),
                  fontSize: 14.0,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: AppColors.border.withOpacity(0.4),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLength: 200,
              style: const TextStyle(
                fontSize: 14.0,
                color: AppColors.textPrimary,
              ),
            );
          },
        ),
      ],
    );
  }
}

class SubmitButtonSection extends StatelessWidget {
  const SubmitButtonSection({
    super.key,
    required this.descriptionController,
    required this.addressDetails,
  });

  final TextEditingController descriptionController;
  final TextEditingController addressDetails;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateReportCubit, CreateReportState>(
      builder: (BuildContext context, CreateReportState state) {
        final isLoading = state is SubmitReportLoading;
        return SizedBox(
          width: double.infinity,
          height: 52.0,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<CreateReportCubit>().submitReport(
                      description: descriptionController.text,
                      addressDetails: addressDetails.text,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 1,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "Submit Report",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
