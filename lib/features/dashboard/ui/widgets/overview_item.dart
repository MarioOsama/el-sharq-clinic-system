import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';

class OverviewItem extends StatelessWidget {
  const OverviewItem({
    super.key,
    required this.title,
    required this.value,
    required this.iconData,
    this.decimals = 0,
  });

  final String title;
  final double value;
  final IconData iconData;
  final int? decimals;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: _buildContainerDecoration(),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 50,
            color: AppColors.darkGrey,
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  clipBehavior: Clip.antiAlias,
                  child: Text(
                    value.toStringAsFixed(decimals!),
                    style: AppTextStyles.font32DarkGreyMedium.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.blue),
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.font18DarkGreyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.darkGrey.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.15),
            blurRadius: 3,
            spreadRadius: 2,
            offset: const Offset(2, 2),
          ),
        ]);
  }
}
