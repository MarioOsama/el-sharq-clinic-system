import 'package:easy_localization/easy_localization.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: _buildContainerDecoration(),
        child: ListTile(
          leading: Icon(
            drawerItemModel.icon,
            color: isSelected ? AppColors.white : AppColors.darkGrey,
          ),
          title: _buildTitle(drawerItemModel.title, isSelected, context),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: isSelected ? AppColors.blue : AppColors.white,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Text _buildTitle(String title, bool isSelected, BuildContext context) {
    return Text(
      title.tr(),
      style: AppTextStyles.font18DarkGreyMedium(context).copyWith(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? AppColors.white : AppColors.darkGrey,
      ),
    );
  }
}
