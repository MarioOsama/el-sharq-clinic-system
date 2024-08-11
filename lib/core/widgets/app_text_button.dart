import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.width,
      this.height,
      this.filled = true});

  final String text;
  final void Function() onPressed;
  final double? width;
  final double? height;
  final bool? filled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: Size(
          width ?? 300.w,
          height ?? 60.h,
        ),
        backgroundColor: filled! ? AppColors.blue : AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: !filled!
              ? const BorderSide(
                  color: AppColors.darkGrey,
                  width: 1,
                )
              : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: Text(text,
          style: AppTextStyles.font20DarkGreyMedium.copyWith(
              color: filled!
                  ? AppColors.white
                  : AppColors.darkGrey.withOpacity(0.5))),
    );
  }
}
