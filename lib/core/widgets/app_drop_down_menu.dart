import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropDownMenu<T> extends StatelessWidget {
  const AppDropDownMenu({
    super.key,
    required this.hint,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.enabled,
    this.controller,
  });

  final String hint;
  final List<T> items;
  final TextEditingController? controller;
  final DropdownMenuEntry<String> Function(int index) itemBuilder;
  final void Function(String? vlaue) onChanged;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: AppTextStyles.font16DarkGreyMedium
              .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
        ),
        DropdownMenu(
          controller: controller,
          dropdownMenuEntries: _getEntries(),
          onSelected: onChanged,
          enableFilter: true,
          filterCallback: _onFilteredDoctors,
          enabled: enabled ?? true,
          textStyle: AppTextStyles.font20DarkGreyMedium,
          inputDecorationTheme: _buildDecorationTheme(),
          menuStyle: MenuStyle(
            fixedSize: WidgetStatePropertyAll(Size(double.infinity, 160.h)),
          ),
          expandedInsets: const EdgeInsets.all(0),
        ),
      ],
    );
  }

  InputDecorationTheme _buildDecorationTheme() {
    return InputDecorationTheme(
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.grey),
      ),
      filled: true,
      fillColor: enabled ?? false ? AppColors.white : AppColors.grey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.darkGrey),
      ),
    );
  }

  List<DropdownMenuEntry<String>> _onFilteredDoctors(
      List<DropdownMenuEntry<String>> entries, String filter) {
    final filteredEntries = entries
        .where(
            (entry) => entry.label.toLowerCase().contains(filter.toLowerCase()))
        .toList();

    return filteredEntries.isEmpty ? entries : filteredEntries;
  }

  List<DropdownMenuEntry<String>> _getEntries() {
    return List.generate(items.length, (index) {
      return itemBuilder(index);
    });
  }
}
