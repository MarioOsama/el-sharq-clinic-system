import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/settings_segmented_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildSegmentedButtonListTile('Language', ['English', 'Arabic']),
          verticalSpace(40.h),
          _buildSegmentedButtonListTile('Theme', ['Light', 'Dark']),
          verticalSpace(40.h),
          ListTile(
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
              initialValue: '5',
              insideHint: true,
              hint: 'Limit',
              numeric: true,
            ),
          ),
          verticalSpace(40.h),
          const Divider(),
          verticalSpace(10.h),
          _buildSideSheetListTile('Change Password', () {}),
          verticalSpace(10.h),
          const Divider(),
          verticalSpace(10.h),
          _buildSideSheetListTile('Change Clinic Name', () {}),
          verticalSpace(10.h),
          const Divider(),
          verticalSpace(10.h),
          _buildSideSheetListTile('Add User Account', () {}),
        ],
      ),
    );
  }

  ListTile _buildSideSheetListTile(String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTextStyles.font24DarkGreyMedium,
      ),
      trailing: const Icon(Icons.keyboard_arrow_right_sharp, size: 40),
    );
  }

  ListTile _buildSegmentedButtonListTile(String title, List<String> values) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTextStyles.font24DarkGreyMedium,
      ),
      trailing: SizedBox(
        width: 300.w,
        height: 50.h,
        child: SettingsSegmentedButton<String>(
          selected: values.first,
          titles: values,
        ),
      ),
    );
  }
}
