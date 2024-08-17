import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.alertMessage,
    required this.onConfirm,
    required this.onCancel,
  });

  final String alertMessage;
  final void Function() onConfirm;
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      icon: Icon(
        Icons.warning,
        color: AppColors.darkGrey.withOpacity(0.75),
        size: 60.sp,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
      content: _buildContent(),
      actions: _getActionsList(context),
    );
  }

  List<Widget> _getActionsList(BuildContext context) {
    return [
      TextButton(
        onPressed: onCancel,
        child: const Text(
          'Cancel',
          style: AppTextStyles.font14DarkGreyMedium,
        ),
      ),
      TextButton(
        onPressed: onConfirm,
        child: const Text(
          'Delete',
          style: AppTextStyles.font14DarkGreyMedium,
        ),
      ),
    ];
  }

  Container _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      width: double.infinity,
      color: AppColors.yellow.withOpacity(0.75),
      child: Text(
        alertMessage,
        style: AppTextStyles.font16DarkGreyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
