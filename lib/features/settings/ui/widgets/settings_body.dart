import 'package:animate_do/animate_do.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';
import 'package:el_sharq_clinic/features/settings/logic/cubit/settings_cubit.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/action_list_tile.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/admin_privileges_container.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/change_password_dialog.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/segmented_button_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final authData = context.watch<SettingsCubit>().newAuthData!;
    return SectionDetailsContainer(
      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 40.w),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            current is SettingsInitial ||
            current is SettingsUpdated ||
            current is SettingsLoading ||
            current is SettingsError,
        builder: (context, state) {
          return _buildChild(authData, context, state);
        },
      ),
    );
  }

  Widget _buildChild(
      AuthDataModel authData, BuildContext context, SettingsState state) {
    if (state is SettingsInitial || state is SettingsUpdated) {
      return _buildSuccess(authData, context);
    } else if (state is SettingsError) {
      return _buildError(state, context);
    }
    return _buildLoading();
  }

  Center _buildError(SettingsError state, BuildContext context) {
    return Center(
      child: Text(
        state.message,
        style: AppTextStyles.font24DarkGreyMedium(context),
      ),
    );
  }

  Center _buildLoading() {
    return const Center(
      child: AnimatedLoadingIndicator(),
    );
  }

  SingleChildScrollView _buildSuccess(
      AuthDataModel authData, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          BounceInLeft(
            child: _buildSegmentedButtonListTile(
              'Language',
              ['English', 'Arabic'],
              authData.language,
              context,
              onLanguageChanged,
            ),
          ),
          verticalSpace(40.h),
          // BounceInLeft(
          //   child: _buildSegmentedButtonListTile(
          //     'Theme',
          //     ['Light', 'Dark'],
          //     authData.theme,
          //     context,
          //     onThemeChanged,
          //   ),
          // ),
          // verticalSpace(40.h),
          BounceInLeft(child: _buildLowStockListTile(authData, context)),
          const Divider(
            color: AppColors.grey,
            thickness: 2,
            height: 100,
          ),
          BounceInRight(
            child: ActionListTile(
              title: 'Change Password',
              onTap: () => showChangePasswordSideSheet(context),
              iconData: Icons.lock,
            ),
          ),
          if (authData.userModel.role == UserType.admin)
            BounceInRight(child: const AdminPrivilegesContainer()),
        ],
      ),
    );
  }

  ListTile _buildLowStockListTile(
      AuthDataModel authData, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Low Stock Limit',
        style: AppTextStyles.font24DarkGreyMedium(context),
      ),
      subtitle: Text(
        'The default low stock limit is 5',
        style: AppTextStyles.font16DarkGreyMedium(context).copyWith(
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
      builder: (_) => ChangePasswordDialog(
        onPasswordChanged: context.read<SettingsCubit>().onChangePassword,
      ),
    );
  }
}
