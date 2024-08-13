import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/date_time_picker.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/appointments/logic/cubit/appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showAppointmentSideSheet(BuildContext context, String title,
    {required bool? isNew}) async {
  final AppointmentsCubit appointmentsCubit = context.read<AppointmentsCubit>();
  appointmentsCubit.clearAllControllers();
  await showCustomSideSheet(
    context: context,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SectionTitle(title: title),
          verticalSpace(50),
          if (!isNew!) _buildAppointmentId(),
          verticalSpace(50),
          FieldsRow(
            fields: const [
              'Owner Name',
              'Pet Type',
            ],
            firstController: appointmentsCubit.ownerNameController,
            secondController: appointmentsCubit.petTypeController,
            enabled: isNew,
          ),
          verticalSpace(50),
          FieldsRow(
            fields: const [
              'Phone',
              'Pet Name',
            ],
            firstController: appointmentsCubit.phoneController,
            secondController: appointmentsCubit.petNameController,
            enabled: isNew,
          ),
          verticalSpace(50),
          FieldsRow(
            fields: const [
              'Time',
              'Date',
            ],
            firstController: appointmentsCubit.timeController,
            secondController: appointmentsCubit.dateController,
            firstSuffixIcon:
                _buildTimeButton(context, appointmentsCubit.timeController),
            secondSuffixIcon:
                _buildDateButton(context, appointmentsCubit.dateController),
            enabled: isNew,
            readOnly: true,
          ),
          verticalSpace(50),
          AppTextField(
            controller: appointmentsCubit.petConditionController,
            hint: 'Pet Condition',
            enabled: isNew,
            width: double.infinity,
            height: 200,
            isMultiline: true,
            insideHint: false,
          ),
          verticalSpace(100),
          isNew ? _buildNewAction(context) : _buildExistActions(),
        ],
      ),
    ),
  );
}

IconButton _buildDateButton(
    BuildContext context, TextEditingController controller) {
  return IconButton(
      onPressed: () async {
        await customDatePicker(context, controller);
      },
      icon: const Icon(
        Icons.calendar_today,
        color: AppColors.darkGrey,
      ));
}

IconButton _buildTimeButton(
    BuildContext context, TextEditingController controller) {
  return IconButton(
      onPressed: () async {
        await customTimePicker(context, controller);
      },
      icon: const Icon(
        Icons.access_time,
        color: AppColors.darkGrey,
      ));
}

AppTextField _buildAppointmentId() {
  return AppTextField(
    controller: TextEditingController(),
    hint: 'Appointment ID',
    enabled: false,
    width: double.infinity,
    insideHint: false,
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
      text: 'Save Appointment',
      width: context.size!.width,
      onPressed: () {
        context.read<AppointmentsCubit>().validateAndSave();
      });
}
