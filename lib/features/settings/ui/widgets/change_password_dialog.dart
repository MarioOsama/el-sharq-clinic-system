import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordDialog extends StatelessWidget {
  const ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 450.w,
        height: 550.h,
        child: Form(
          child: _buildDialogBody(context),
        ),
      ),
    );
  }
}

Widget _buildDialogBody(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        verticalSpace(40),
        const SectionTitle(title: 'Change Password'),
        verticalSpace(30),
        _buildCurrentPasswordTextField(),
        verticalSpace(30),
        _buildNewPasswordTextField(),
        verticalSpace(30),
        _buildConfirmNewPasswordTextField(),
        const Spacer(),
        _buildActionButtons(context),
        verticalSpace(20),
      ],
    ),
  );
}

Widget _buildCurrentPasswordTextField() {
  return AppTextField(
    maxWidth: double.infinity,
    hint: 'Current Password',
    isObscured: true,
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter a password';
      }
      return null;
    },
  );
}

Widget _buildNewPasswordTextField() {
  return AppTextField(
    maxWidth: double.infinity,
    hint: 'New Password',
    isObscured: true,
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter a password';
      }
      return null;
    },
  );
}

Widget _buildConfirmNewPasswordTextField() {
  return AppTextField(
    maxWidth: double.infinity,
    hint: 'Confirm New Password',
    isObscured: true,
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter a password';
      }
      return null;
    },
  );
}

Widget _buildActionButtons(BuildContext context) {
  return Row(
    children: [
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
          text: 'Confirm',
          onPressed: () {},
        ),
      ),
    ],
  );
}
