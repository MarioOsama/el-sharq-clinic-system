import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/home/data/models/drawer_item_model.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.drawerItemModel,
    required this.isSelected,
  });

  final DrawerItemModel drawerItemModel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: _buildContainerDecoration(),
        child: ListTile(
          leading: Icon(
            drawerItemModel.icon,
            color: isSelected ? AppColors.white : AppColors.darkGrey,
          ),
          title: _buildTitle(drawerItemModel.title, isSelected),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: isSelected ? AppColors.blue : AppColors.white,
      borderRadius: BorderRadius.circular(10),
    );
  }

  Text _buildTitle(String title, bool isSelected) {
    return Text(
      title,
      style: AppTextStyles.font16DarkGreyMedium.copyWith(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? AppColors.white : AppColors.darkGrey,
      ),
    );
  }
}
