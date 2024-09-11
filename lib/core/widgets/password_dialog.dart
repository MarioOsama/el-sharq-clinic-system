import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordDialog extends StatefulWidget {
  const PasswordDialog(
      {super.key,
      required this.actionTitle,
      required this.onActionPressed,
      this.title});

  final String? title;
  final String actionTitle;
  final void Function(String password) onActionPressed;

  @override
  State<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<PasswordDialog> {
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 450.w,
        height: 350.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalSpace(40),
            Container(
              color: AppColors.darkGrey,
              width: MediaQuery.sizeOf(context).width,
              height: 40.h,
              alignment: Alignment.center,
              child: Text(
                widget.title ?? 'Enter your password',
                style: AppTextStyles.font16DarkGreyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            verticalSpace(60),
            AppTextField(
              controller: passwordController,
              hint: 'Password',
              isObscured: true,
              insideHint: true,
              maxWidth: 410.w,
              maxHeight: 60.h,
            ),
            verticalSpace(40),
            Row(
              children: [
                horizontalSpace(20),
                Expanded(
                  child: AppTextButton(
                      height: 55.h,
                      text: 'Cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                horizontalSpace(20),
                Expanded(
                  child: AppTextButton(
                      height: 55.h,
                      color: AppColors.red,
                      text: widget.actionTitle,
                      onPressed: () {
                        widget.onActionPressed(passwordController.text);
                      }),
                ),
                horizontalSpace(20),
              ],
            ),
            verticalSpace(40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
