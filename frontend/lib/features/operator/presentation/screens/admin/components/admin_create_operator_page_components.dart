import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/operator/domain/entities/municipality.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_cubit.dart';
import 'package:frontend/features/operator/presentation/cubit/create_operator_state.dart';
import 'package:frontend/features/operator/presentation/cubit/get_municipalities_cubit.dart';
import 'package:frontend/features/operator/presentation/cubit/get_municipalities_state.dart';

class MunicipalityAutocomplete extends StatefulWidget {
  const MunicipalityAutocomplete({
    super.key,
    required this.onSelect,
    required this.enabled,
  });

  final Function(Municipality municipality) onSelect;
  final bool enabled;

  @override
  State<MunicipalityAutocomplete> createState() =>
      _MunicipalityAutocompleteState();
}

class _MunicipalityAutocompleteState extends State<MunicipalityAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMunicipalitiesCubit, GetMunicipalitiesState>(
      builder: (BuildContext context, GetMunicipalitiesState state) {
        List<Municipality> municipalities = [];
        if (state is GetMunicipalitiesSuccess) {
          municipalities = state.municipalities;
        }
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: Autocomplete<Municipality>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              // Show all when empty
              if (textEditingValue.text.isEmpty) {
                return municipalities;
              }

              return municipalities.where(
                (municipality) => municipality.name.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
              );
            },

            onSelected: widget.onSelect,

            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,

                    decoration: InputDecoration(
                      hintText: "Choose municipality",

                      prefixIcon: const Icon(Icons.location_city),
                      suffixIcon: state is GetMunicipalitiesLoading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : state is GetMunicipalitiesFailure
                          ? Tooltip(
                              message: state.error,
                              child: const Icon(Icons.error_outline),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },

            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 300,
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);

                        return ListTile(
                          title: Text(option.name),
                          onTap: () {
                            onSelected(option);
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CreateOperatorForm extends StatefulWidget {
  const CreateOperatorForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<CreateOperatorForm> createState() => _CreateOperatorFormState();
}

class _CreateOperatorFormState extends State<CreateOperatorForm> {
  Municipality? selectedMunicipality;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(color: AppColors.border),
      ),
      padding: .all(20.0),
      child: BlocBuilder<CreateOperatorCubit, CreateOperatorState>(
        builder: (BuildContext context, CreateOperatorState state) {
          return Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              CustomField(
                text: "Work Email Address",
                hintText: "example@civicpulse.gov",
                controller: widget.emailController,
                enabled: (state is CreateOperatorLoading) ? false : true,
              ),
              const SizedBox(height: 10.0),
              CustomField(
                text: "Password",
                hintText: "********",
                controller: widget.passwordController,
                enabled: (state is CreateOperatorLoading) ? false : true,
              ),
              const SizedBox(height: 10.0),
              const BoldText(
                text: "Assigned Municipality",
                size: 20.0,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 5.0),
              MunicipalityAutocomplete(
                onSelect: (Municipality municipality) {
                  selectedMunicipality = municipality;
                },
                enabled: (state is CreateOperatorLoading) ? false : true,
              ),
              const SizedBox(height: 20.0),
              Align(
                alignment: .center,
                child: ActionButton(
                  buttonWidth: 400,
                  text: "Register Operator",
                  textColor: Colors.white,
                  textSize: 30.0,
                  buttonColor: (state is CreateOperatorLoading)
                      ? AppColors.buttonTextDisabled
                      : AppColors.buttonPrimary,
                  isValid: (state is CreateOperatorLoading) ? false : true,
                  onPressed: () {
                    context.read<CreateOperatorCubit>().createOperator(
                      email: widget.emailController.text.trim(),
                      password: widget.passwordController.text.trim(),
                      municipalityId: selectedMunicipality!.id,
                    );
                  },
                  borderColor: Colors.transparent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CreateOperatorResultDialog {
  static Future<void> showOperatorDialog({
    required BuildContext context,
    required bool success,
    required String message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: success
                        ? Colors.green.withValues(alpha: .1)
                        : Colors.red.withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    success ? Icons.check_rounded : Icons.close_rounded,
                    size: 45,
                    color: success ? Colors.green : Colors.red,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  success ? "Operator Created" : "Creation Failed",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
