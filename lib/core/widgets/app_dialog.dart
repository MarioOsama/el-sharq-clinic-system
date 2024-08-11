import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/animated_dialog_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.dialogType,
    this.action,
  });

  final String title;
  final String content;
  final DialogType dialogType;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
        height: 350.h,
        width: 500.w,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: action != null ? 150.h : 175.h,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: _buildContainerDecoration(),
                child: AnimatedDialogIcon(
                  dialogType: dialogType,
                ),
              ),
            ),
            action != null ? verticalSpace(20) : verticalSpace(60),
            Text(
              title,
              style: AppTextStyles.font20DarkGreyMedium,
            ),
            Text(
              content,
              style: AppTextStyles.font16DarkGreyMedium,
            ),
            if (action != null) const Spacer(),
            if (action != null) action!,
            if (action != null) verticalSpace(20),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      color: dialogType == DialogType.alert
          ? Colors.yellow
          : dialogType == DialogType.success
              ? Colors.green
              : Colors.red,
    );
  }
}

enum DialogType {
  alert,
  success,
  error,
}
