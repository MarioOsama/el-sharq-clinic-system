import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddUserAccountDialog extends StatefulWidget {
  const AddUserAccountDialog({super.key, required this.onAccountAdded});

  final void Function(String name, String password) onAccountAdded;

  @override
  State<AddUserAccountDialog> createState() => _AddUserAccountDialogState();
}

class _AddUserAccountDialogState extends State<AddUserAccountDialog> {
  late TextEditingController _nameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 450.w,
        height: 450.h,
        child: Form(
          child: _buildDialogBody(context),
        ),
      ),
    );
  }

  Padding _buildDialogBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpace(40),
          const SectionTitle(title: 'Add User Account'),
          verticalSpace(40),
          _buildNameTextField(),
          verticalSpace(20),
          _buildPasswordTextField(),
          verticalSpace(40),
          _buildActionButtons(context),
          verticalSpace(20),
        ],
      ),
    );
  }

  AppTextField _buildNameTextField() {
    return AppTextField(
      controller: _nameController,
      hint: 'Name',
      maxWidth: double.infinity,
      maxHeight: 90.h,
    );
  }

  AppTextField _buildPasswordTextField() {
    return AppTextField(
      controller: _passwordController,
      hint: 'Password',
      isObscured: true,
      maxWidth: double.infinity,
      maxHeight: 90.h,
    );
  }

  Row _buildActionButtons(BuildContext context) {
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
              text: 'Add',
              onPressed: () {
                widget.onAccountAdded(
                    _nameController.text, _passwordController.text);
              }),
        ),
      ],
    );
  }
}
