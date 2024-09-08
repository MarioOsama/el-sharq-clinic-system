import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSegmentedButton<T> extends StatelessWidget {
  const SettingsSegmentedButton(
      {super.key, required this.titles, required this.selected});

  final T selected;
  final List<T> titles;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      // expandedInsets: EdgeInsets.zero,
      selectedIcon: const SizedBox.shrink(),
      onSelectionChanged: (value) {},
      selected: {selected},
      segments: _getSegments(titles),
      style: _buildStyle,
    );
  }

  List<ButtonSegment<T>> _getSegments(List<T> titles) {
    return titles
        .map((title) => ButtonSegment<T>(
              value: title,
              label: Text(
                title.toString(),
                style: AppTextStyles.font24DarkGreyMedium.copyWith(
                  color:
                      selected == title ? AppColors.white : AppColors.darkGrey,
                ),
              ),
            ))
        .toList();
  }

  ButtonStyle get _buildStyle {
    return SegmentedButton.styleFrom(
      alignment: Alignment.center,
      backgroundColor: AppColors.white,
      selectedBackgroundColor: AppColors.blue.withOpacity(0.85),
      selectedForegroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.darkGrey, width: 1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
    );
  }
}
