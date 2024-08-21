import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/date_time_picker.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/case_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showCaseSheet(BuildContext context, String title,
    {CaseHistoryModel? caseHistoryModel, bool editable = true}) async {
  final bool newCase = caseHistoryModel == null;
  final CaseHistoryCubit caseHistoryCubit = context.read<CaseHistoryCubit>();
  newCase
      ? caseHistoryCubit.setupNewModeControllers()
      : caseHistoryCubit.setupShowModeControllers(caseHistoryModel);

  await showCustomSideSheet(
    context: context,
    child: Column(
      children: [
        SectionTitle(title: title),
        verticalSpace(50),
        if (!newCase) _buildCaseId(caseHistoryCubit.caseIdController),
        verticalSpace(50),
        FieldsRow(
          fields: const [
            'Owner Name',
            'Pet Type',
          ],
          firstController: caseHistoryCubit.ownerNameController,
          secondController: caseHistoryCubit.petTypeController,
          enabled: editable,
        ),
        verticalSpace(50),
        FieldsRow(
          fields: const [
            'Phone',
            'Pet Name',
          ],
          firstController: caseHistoryCubit.phoneController,
          secondController: caseHistoryCubit.petNameController,
          enabled: editable,
        ),
        verticalSpace(50),
        FieldsRow(
          fields: const [
            'Time',
            'Date',
          ],
          firstController: caseHistoryCubit.timeController,
          secondController: caseHistoryCubit.dateController,
          firstSuffixIcon:
              _buildTimeButton(context, caseHistoryCubit.timeController),
          secondSuffixIcon:
              _buildDateButton(context, caseHistoryCubit.dateController),
          enabled: editable,
          readOnly: true,
        ),
        verticalSpace(50),
        AppTextField(
          controller: caseHistoryCubit.petReportController,
          hint: 'Pet Report',
          enabled: editable,
          maxWidth: double.infinity,
          isMultiline: true,
          insideHint: false,
        ),
        verticalSpace(100),
        _buildActionIfNeeded(context, newCase, editable),
      ],
    ),
  );
}

_buildActionIfNeeded(BuildContext context, bool newCase, bool editMode) {
  if (newCase) {
    return _buildNewAction(context);
  } else if (editMode) {
    return _buildUpdateAction(context);
  }
  return const SizedBox.shrink();
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

AppTextField _buildCaseId(TextEditingController idController) {
  return AppTextField(
    controller: idController,
    hint: 'Case ID',
    enabled: false,
    maxWidth: double.infinity,
    insideHint: false,
  );
}

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
    text: 'Save Case',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<CaseHistoryCubit>().validateAndSaveCase();
    },
  );
}

AppTextButton _buildUpdateAction(BuildContext context) {
  return AppTextButton(
    text: 'Update Case',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<CaseHistoryCubit>().validateAndUpdateCase();
    },
  );
}
