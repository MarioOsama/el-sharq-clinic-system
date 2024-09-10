import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionListTile extends StatelessWidget {
  const ActionListTile(
      {super.key,
      required this.title,
      required this.onTap,
      required this.iconData});

  final String title;
  final VoidCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
      decoration: _buildBoxDecoration(),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 40,
        title: Text(
          title,
          style: AppTextStyles.font24DarkGreyMedium,
        ),
        trailing: Icon(iconData, size: 20.sp, color: AppColors.blue),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.50),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]);
  }
}
