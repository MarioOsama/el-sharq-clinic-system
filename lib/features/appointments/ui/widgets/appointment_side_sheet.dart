import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/core/widgets/date_time_picker.dart';
import 'package:flutter/material.dart';

Future<void> showAppointmentSideSheet(BuildContext context,
    {bool? editable = true}) async {
  await showCustomSideSheet(
    context: context,
    child: SingleChildScrollView(
      child: Column(
        children: [
          const SectionTitle(title: 'New Appointment'),
          verticalSpace(50),
          AppTextField(
            controller: TextEditingController(),
            hint: 'Owner Name',
            enabled: editable,
            width: double.infinity,
            insideHint: false,
          ),
          verticalSpace(50),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: TextEditingController(),
                  hint: 'Phone',
                  enabled: editable,
                  width: double.infinity,
                  insideHint: false,
                ),
              ),
              horizontalSpace(50),
              Expanded(
                child: AppTextField(
                  controller: TextEditingController(),
                  hint: 'Pet Name',
                  enabled: editable,
                  width: double.infinity,
                  insideHint: false,
                ),
              ),
            ],
          ),
          verticalSpace(50),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: TextEditingController(),
                  hint: 'Time',
                  readOnly: true,
                  enabled: editable,
                  width: double.infinity,
                  insideHint: false,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time_outlined),
                    onPressed: () {
                      customTimePicker(context);
                    },
                  ),
                ),
              ),
              horizontalSpace(50),
              Expanded(
                child: AppTextField(
                  controller: TextEditingController(),
                  hint: 'Date',
                  readOnly: true,
                  enabled: editable,
                  width: double.infinity,
                  insideHint: false,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined),
                    onPressed: () {
                      customDatePicker(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(50),
          AppTextField(
            controller: TextEditingController(),
            hint: 'Pet Condition',
            enabled: editable,
            width: double.infinity,
            height: 200,
            isMultiline: true,
            insideHint: false,
          ),
          verticalSpace(100),
          editable! ? _buildNewAction(context) : _buildExistActions(),
        ],
      ),
    ),
  );
}

Row _buildExistActions() {
  return Row(
    children: [
      Expanded(
        child: AppTextButton(
          text: 'Edit',
          width: double.infinity,
          onPressed: () {},
        ),
      ),
      horizontalSpace(50),
      Expanded(
        child: AppTextButton(
          text: 'Delete',
          width: double.infinity,
          onPressed: () {},
          color: AppColors.red,
        ),
      ),
    ],
  );
}

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
      text: 'Save Appointment', width: context.size!.width, onPressed: () {});
}
