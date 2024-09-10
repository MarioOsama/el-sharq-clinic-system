import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/settings_segmented_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SegmentedButtonListTile<T> extends StatelessWidget {
  const SegmentedButtonListTile(
      {super.key,
      required this.title,
      required this.values,
      required this.selected,
      required this.onSelectionChanged});

  final String title;
  final List<String> values;
  final String selected;
  final void Function(String, BuildContext) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTextStyles.font24DarkGreyMedium,
      ),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300.w, maxHeight: 100.h),
        child: SettingsSegmentedButton<String>(
          onSelectionChanged: (value) => onSelectionChanged(value, context),
          selected: selected,
          titles: values,
        ),
      ),
    );
  }
}
