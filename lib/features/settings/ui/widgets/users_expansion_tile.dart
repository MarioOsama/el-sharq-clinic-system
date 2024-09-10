import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersExpansionTile extends StatelessWidget {
  const UsersExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 7.w),
      decoration: _buildBoxDecoration(),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide.none,
        ),
        childrenPadding: EdgeInsets.symmetric(horizontal: 20.w),
        title: const Text(
          'Users',
          style: AppTextStyles.font24DarkGreyMedium,
        ),
        children: _buildUsersTiles,
      ),
    );
  }

  List<Widget> get _buildUsersTiles {
    return [
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'User 1',
          style: AppTextStyles.font20DarkGreyMedium,
        ),
        trailing: Icon(Icons.delete, size: 20.sp, color: AppColors.red),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'User 2',
          style: AppTextStyles.font20DarkGreyMedium,
        ),
        trailing: Icon(Icons.delete, size: 20.sp, color: AppColors.red),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'User 3',
          style: AppTextStyles.font20DarkGreyMedium,
        ),
        trailing: Icon(Icons.delete, size: 20.sp, color: AppColors.red),
      ),
    ];
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
