import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.maxWidth,
    this.maxHeight,
    this.textStyle,
    this.fillColor,
    this.isObscured,
    this.isMultiline,
    this.insideHint = false,
    this.suffixIcon,
    this.enabled,
    this.readOnly,
    this.validator,
    this.initialValue,
    this.onSaved,
  });

  final TextEditingController? controller;
  final String? hint;
  final double? maxWidth;
  final double? maxHeight;
  final TextStyle? textStyle;
  final Color? fillColor;
  final bool? isObscured;
  final bool? isMultiline;
  final bool? insideHint;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final String? initialValue;
  final void Function(String? value)? onSaved;

  @override
  Widget build(BuildContext context) {
    return insideHint!
        ? _buildTextFieldWithInsideHint(hint)
        : _buildTextFieldWithOutsideHint();
  }

  Column _buildTextFieldWithOutsideHint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint!,
          style: AppTextStyles.font16DarkGreyMedium
              .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
        ),
        _buildTextFieldWithInsideHint(null),
      ],
    );
  }

  TextFormField _buildTextFieldWithInsideHint(String? hint) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      initialValue: initialValue,
      style: AppTextStyles.font20DarkGreyMedium,
      obscureText: isObscured ?? false,
      cursorHeight: 30.h,
      maxLines: isMultiline ?? false ? 30 : 1,
      minLines: 1,
      enabled: enabled,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey),
        ),
        suffixIcon: suffixIcon,
        hintText: hint,
        fillColor: enabled ?? true ? AppColors.white : AppColors.grey,
        filled: true,
        hintStyle: textStyle ??
            AppTextStyles.font20DarkGreyMedium
                .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkGrey),
        ),
        constraints: BoxConstraints(
          maxHeight: maxHeight ?? double.infinity,
          maxWidth: maxWidth ?? 300.w,
        ),
      ),
    );
  }
}
