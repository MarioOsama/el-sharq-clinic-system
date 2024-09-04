import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeparationLine extends StatelessWidget {
  const SeparationLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.h,
      width: double.infinity,
      color: AppColors.lightBlue,
    );
  }
}
