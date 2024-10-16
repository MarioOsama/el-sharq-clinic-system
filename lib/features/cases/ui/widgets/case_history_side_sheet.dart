import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_drop_down_menu.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/date_time_picker.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/cases_cubit.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showCaseSheet(BuildContext context, String title,
    {CaseHistoryModel? caseHistoryModel, bool editable = true}) async {
  final bool newCase = caseHistoryModel == null;
  final CasesCubit casesCubit = context.read<CasesCubit>();
  newCase
      ? casesCubit.setupNewModeControllers()
      : casesCubit.setupShowModeControllers(caseHistoryModel);
  final List<DoctorModel> doctorsList = context.read<CasesCubit>().doctorsList;

  await showCustomSideSheet(
    context: context,
    child: Column(
      children: [
        SectionTitle(title: title),
        verticalSpace(50),
        if (!newCase) _buildCaseId(casesCubit.caseIdController),
        if (!newCase) verticalSpace(50),
        AppDropDownMenu<DoctorModel>(
          hint: editable ? AppStrings.doctor.tr() : AppStrings.doctorId.tr(),
          controller: casesCubit.doctorNameController,
          itemBuilder: (index) => DropdownMenuEntry(
            label: doctorsList[index].name,
            value: doctorsList[index].id,
            labelWidget: _buildDoctorLabel(doctorsList[index], context),
          ),
          items: casesCubit.doctorsList,
          onChanged: (value) {
            casesCubit.onSelectDoctor(value);
          },
          enabled: editable,
        ),
        verticalSpace(50),
        FieldsRow(
          fields: const [
            AppStrings.ownerName,
            AppStrings.petType,
          ],
          firstController: casesCubit.ownerNameController,
          secondController: casesCubit.petTypeController,
          enabled: editable,
        ),
        verticalSpace(50),
        FieldsRow(
          fields: const [
            AppStrings.phone,
            AppStrings.petName,
          ],
          firstController: casesCubit.phoneController,
          secondController: casesCubit.petNameController,
          enabled: editable,
        ),
        verticalSpace(50),
        FieldsRow(
          fields: const [
            AppStrings.time,
            AppStrings.date,
          ],
          firstController: casesCubit.timeController,
          secondController: casesCubit.dateController,
          firstSuffixIcon: _buildTimeButton(context, casesCubit.timeController),
          secondSuffixIcon:
              _buildDateButton(context, casesCubit.dateController),
          enabled: editable,
          readOnly: true,
        ),
        verticalSpace(50),
        AppTextField(
          controller: casesCubit.petReportController,
          hint: AppStrings.petReport.tr(),
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

Row _buildDoctorLabel(DoctorModel doctorsList, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        doctorsList.name,
        style: AppTextStyles.font16DarkGreyMedium(context),
      ),
      Text(
        doctorsList.id,
        style: AppTextStyles.font16DarkGreyMedium(context),
      ),
    ],
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
    hint: AppStrings.caseId.tr(),
    enabled: false,
    maxWidth: double.infinity,
    insideHint: false,
  );
}

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
    text: AppStrings.saveCase.tr(),
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<CasesCubit>().validateAndSaveCase();
    },
  );
}

AppTextButton _buildUpdateAction(BuildContext context) {
  return AppTextButton(
    text: AppStrings.updateCase.tr(),
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<CasesCubit>().validateAndUpdateCase();
    },
  );
}
