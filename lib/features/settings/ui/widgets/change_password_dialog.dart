import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key, required this.onPasswordChanged});

  final void Function(String currentPassword, String newPassword)
      onPasswordChanged;

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

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
      controller: _currentPasswordController,
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
      controller: _newPasswordController,
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
      controller: _confirmNewPasswordController,
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
                context.pop();
              }),
        ),
        horizontalSpace(20),
        Expanded(
          child: AppTextButton(
            height: 55.h,
            text: 'Confirm',
            onPressed: () {
              if (_validateInputs()) {
                widget.onPasswordChanged(_currentPasswordController.text,
                    _newPasswordController.text);
                context.pop();
              }
            },
          ),
        ),
      ],
    );
  }

  bool _validateInputs() {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmNewPasswordController.text.isEmpty) {
      showErrorDialog(context, 'Please fill in all fields');

      return false;
    }
    if (_newPasswordController.text.trim() !=
        _confirmNewPasswordController.text.trim()) {
      showErrorDialog(context, 'Passwords do not match');

      return false;
    }
    return true;
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) => AppDialog(
              title: 'Error',
              content: message,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: 'OK',
                filled: false,
                onPressed: () {
                  context.pop();
                },
              ),
            ));
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
