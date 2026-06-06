import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';
import 'package:frontend/features/auth/presentation/cubit/auth_cubit.dart';

class AdminSideBar extends StatelessWidget {
  const AdminSideBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final Function(int index) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),

                const SizedBox(width: 5.0),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldText(
                      text: "Civic Authority",
                      size: 15.0,
                      color: AppColors.textPrimary,
                    ),

                    NormalText(
                      text: "Admin Portal",
                      size: 15.0,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          _navItem(
            title: "Create Operator",
            index: 0,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 5.0),
          _navItem(title: "Rerouting Reports", index: 1, icon: Icons.route),
          const SizedBox(height: 10.0),
          _navItem(title: "Abuse Reports", index: 2, icon: Icons.report_sharp),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ActionButton(
              text: "Logout",
              textColor: Colors.white,
              textSize: 18.0,
              buttonColor: Colors.red,
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              borderColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : AppColors.textPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : AppColors.textPrimary,
        ),
      ),
      selected: isSelected,
      onTap: () {
        onItemSelected(index);
      },
    );
  }
}
