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
      this.filled = true,
      this.icon,
      this.color,
      this.textStyle,
      this.enabled = true});

  final String text;
  final void Function() onPressed;
  final double? width;
  final double? height;
  final bool? filled;
  final IconData? icon;
  final Color? color;
  final TextStyle? textStyle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return icon != null ? _buildTextButtonWithIcon() : _buildTextButton();
  }

  TextButton _buildTextButton() {
    return TextButton(
      style: _buildButtonStyle(),
      onPressed: enabled ? onPressed : null,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text,
            style: textStyle ??
                AppTextStyles.font20DarkGreyMedium.copyWith(
                    color: filled!
                        ? AppColors.white
                        : AppColors.darkGrey.withOpacity(0.5))),
      ),
    );
  }

  TextButton _buildTextButtonWithIcon() {
    return TextButton.icon(
      style: _buildButtonStyle(),
      onPressed: enabled ? onPressed : null,
      icon: Icon(
        icon,
        color: AppColors.white,
      ),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text,
            style: textStyle ??
                AppTextStyles.font20DarkGreyMedium.copyWith(
                    color: filled!
                        ? AppColors.white
                        : AppColors.darkGrey.withOpacity(0.5))),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? 300.w,
        height ?? 50.h,
      ),
      backgroundColor: enabled
          ? filled!
              ? color ?? AppColors.blue
              : AppColors.white
          : AppColors.darkGrey.withOpacity(0.5),
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
    );
  }
}
