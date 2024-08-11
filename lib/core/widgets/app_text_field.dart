import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.width,
    this.height,
    this.textStyle,
    this.fillColor,
    this.isObscured,
  });

  final TextEditingController controller;
  final String hint;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? fillColor;
  final bool? isObscured;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: AppTextStyles.font20DarkGreyMedium,
      obscureText: isObscured ?? false,
      cursorHeight: 30.h,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: AppColors.white,
        filled: true,
        hintStyle: textStyle ??
            AppTextStyles.font20DarkGreyMedium
                .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkGrey),
        ),
        constraints: BoxConstraints(
          maxHeight: height ?? 60.h,
          maxWidth: width ?? 300.w,
        ),
      ),
    );
  }
}
