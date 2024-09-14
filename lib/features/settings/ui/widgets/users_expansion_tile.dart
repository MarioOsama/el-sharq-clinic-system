import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/password_dialog.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';
import 'package:el_sharq_clinic/features/settings/logic/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersExpansionTile extends StatelessWidget {
  const UsersExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 7.w),
      decoration: _buildBoxDecoration(),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide.none,
        ),
        childrenPadding: EdgeInsets.symmetric(horizontal: 20.w),
        title: Text(
          AppStrings.users.tr(),
          style: AppTextStyles.font24DarkGreyMedium(context),
        ),
        children: _buildUsersTiles(context),
      ),
    );
  }

  List<Widget> _buildUsersTiles(BuildContext context) {
    return context
        .watch<SettingsCubit>()
        .clinicUsers
        .map((user) => ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 10,
              title: Text(
                user.userName,
                style: AppTextStyles.font20DarkGreyMedium(context),
              ),
              trailing: user.role == UserType.admin
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon:
                          Icon(Icons.delete, size: 20.sp, color: AppColors.red),
                      onPressed: () {
                        _onDeleteUserAccount(context, user);
                      },
                    ),
            ))
        .toList();
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
        color: const Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withOpacity(0.50),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]);
  }

  void _onDeleteUserAccount(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (_) => AppAlertDialog(
        alertMessage: AppStrings.deleteAccountConfirmation.tr(),
        onConfirm: () async {
          await showAdminPasswordInquiryDialog(context, user.id);
          if (context.mounted) {
            context.pop();
          }
        },
        onCancel: () {
          context.pop();
        },
      ),
    );
  }

  Future<void> showAdminPasswordInquiryDialog(
      BuildContext context, String userId) async {
    await showDialog(
      context: context,
      builder: (_) => PasswordDialog(
          title: AppStrings.enterAdminPassword.tr(),
          actionTitle: AppStrings.deleteAccount.tr(),
          onActionPressed: (password) {
            final bool isAdmin =
                context.read<SettingsCubit>().checkAdminPassword(password);
            if (isAdmin) {
              context.read<SettingsCubit>().onAccountDeleted(userId);
              context.pop();
            } else {
              showError(context, AppStrings.adminPasswordIncorrect.tr());
            }
          }),
    );
  }

  void showError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) => AppDialog(
              title: AppStrings.error.tr(),
              content: message,
              dialogType: DialogType.error,
              action: AppTextButton(
                text: AppStrings.ok.tr(),
                filled: false,
                onPressed: () => context.pop(),
              ),
            ));
  }
}
