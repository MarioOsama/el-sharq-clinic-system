import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/settings/logic/cubit/settings_cubit.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/action_list_tile.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/add_user_account_dialog.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/change_clinic_name_dialog.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/change_password_dialog.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/segmented_button_list_tile.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/users_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final authData = context.read<SettingsCubit>().authData!;
    return SectionDetailsContainer(
      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 40.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildSegmentedButtonListTile(
              'Language',
              ['English', 'Arabic'],
              authData.language,
              context,
              onLanguageChanged,
            ),
            verticalSpace(40.h),
            _buildSegmentedButtonListTile(
              'Theme',
              ['Light', 'Dark'],
              authData.theme,
              context,
              onThemeChanged,
            ),
            verticalSpace(40.h),
            _buildLowStockListTile(authData, context),
            const Divider(
              color: AppColors.grey,
              thickness: 2,
              height: 100,
            ),
            ActionListTile(
              title: 'Change Password',
              onTap: () => showChangePasswordSideSheet(context),
              iconData: Icons.lock,
            ),
            verticalSpace(20.h),
            ActionListTile(
              title: 'Change Clinic Name',
              onTap: () => showClinicNameDialog(context, authData.clinicName),
              iconData: Icons.edit,
            ),
            verticalSpace(20.h),
            ActionListTile(
              title: 'Add User Account',
              onTap: () => showAddUserAccountDialog(context),
              iconData: Icons.person_add,
            ),
            verticalSpace(20.h),
            const UsersExpansionTile(),
          ],
        ),
      ),
    );
  }

  ListTile _buildLowStockListTile(
      AuthDataModel authData, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        'Low Stock Limit',
        style: AppTextStyles.font24DarkGreyMedium,
      ),
      subtitle: Text(
        'The default low stock limit is 5',
        style: AppTextStyles.font16DarkGreyMedium.copyWith(
          color: Colors.grey,
        ),
      ),
      trailing: AppTextField(
        maxHeight: 50.h,
        initialValue: authData.lowStockLimit.toString(),
        insideHint: true,
        hint: 'Limit',
        numeric: true,
        onChanged: (value) => onLowStockLimitChanged(value, context),
      ),
    );
  }

  SegmentedButtonListTile _buildSegmentedButtonListTile(
    String title,
    List<String> values,
    String selected,
    BuildContext context,
    Function(String, BuildContext) onSelectionChanged,
  ) {
    return SegmentedButtonListTile(
        title: title,
        values: values,
        selected: selected,
        onSelectionChanged: onSelectionChanged);
  }

  void onLanguageChanged(String value, BuildContext context) {
    context.read<SettingsCubit>().changeLanguage(value);
  }

  void onThemeChanged(String value, BuildContext context) {
    context.read<SettingsCubit>().changeTheme(value);
  }

  void onLowStockLimitChanged(String value, BuildContext context) {
    context
        .read<SettingsCubit>()
        .changeLowStockLimit(double.tryParse(value) ?? 0);
  }

  void showChangePasswordSideSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const ChangePasswordDialog(),
    );
  }

  void showClinicNameDialog(BuildContext context, String clinicName) {
    showDialog(
      context: context,
      builder: (_) => ChangeClinicNameDialog(
        clinicName: clinicName,
      ),
    );
  }

  void showAddUserAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AddUserAccountDialog(),
    );
  }
}
