import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

Future<void> customDatePicker(
    BuildContext context, TextEditingController controller) async {
  DateTime? date = await showDatePicker(
    context: context,
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.blue,
            onPrimary: AppColors.white,
            surface: Color(0xFFF5F9FF),
          ),
        ),
        child: child!,
      );
    },
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );

  if (date != null) {
    controller.text = date.toString().substring(0, 10);
  }
}

Future<void> customTimePicker(
    BuildContext context, TextEditingController controller) async {
  TimeOfDay? time = await showTimePicker(
    context: context,
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.blue,
            onPrimary: AppColors.white,
            surface: Color(0xFFF5F9FF),
          ),
        ),
        child: child!,
      );
    },
    initialTime: TimeOfDay.now(),
  );

  if (time != null) {
    controller.text = '${time.hour}:${time.minute}';
  }
}
