import 'package:flutter/material.dart';
import 'package:frontend/Component/components.dart';
import 'package:frontend/config/settings/app_colors.dart';

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
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.white),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.blue : Colors.white),
      ),
      selected: isSelected,
      onTap: () {
        onItemSelected(index);
      },
    );
  }
}
