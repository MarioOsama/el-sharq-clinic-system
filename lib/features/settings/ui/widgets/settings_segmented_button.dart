import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSegmentedButton<T> extends StatefulWidget {
  const SettingsSegmentedButton(
      {super.key,
      required this.titles,
      required this.selected,
      required this.onSelectionChanged});

  final T selected;
  final List<T> titles;
  final Function(T value) onSelectionChanged;

  @override
  State<SettingsSegmentedButton<T>> createState() =>
      _SettingsSegmentedButtonState<T>();
}

class _SettingsSegmentedButtonState<T>
    extends State<SettingsSegmentedButton<T>> {
  late T selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      selectedIcon: const SizedBox.shrink(),
      onSelectionChanged: (value) {
        widget.onSelectionChanged(value.first);
        setState(() {
          selected = value.first;
        });
      },
      selected: {selected},
      segments: _getSegments(widget.titles),
      style: _buildStyle,
      expandedInsets: EdgeInsets.zero,
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
      maximumSize: Size(300.w, 100.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    );
  }
}
