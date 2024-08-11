import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropDownButton extends StatelessWidget {
  const AppDropDownButton({
    super.key,
    required this.items,
    this.width,
    this.textStyle,
    required this.onChanged,
  });

  final List<String> items;
  final double? width;
  final TextStyle? textStyle;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    String selectedValue = items.first;

    return Container(
      width: width ?? 300.w,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: _buildContainerDecoration(),
      child: StatefulBuilder(
        builder: (context, setState) => DropdownButton<String>(
          style: textStyle ?? AppTextStyles.font20DarkGreyMedium,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          value: selectedValue,
          borderRadius: BorderRadius.circular(10),
          items: _getItemsList,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
            onChanged(newValue);
          },
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
      border: Border.all(color: AppColors.grey),
    );
  }

  List<DropdownMenuItem<String>> get _getItemsList {
    return items.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList();
  }
}
