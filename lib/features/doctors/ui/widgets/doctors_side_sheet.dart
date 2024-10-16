import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showDoctorSheet(BuildContext context, String title,
    {DoctorModel? doctor, bool editable = true}) async {
  final bool newDoctor = doctor == null;
  final DoctorsCubit doctorsCubit = context.read<DoctorsCubit>();

  newDoctor
      ? doctorsCubit.setupNewSheet()
      : doctorsCubit.setupExistingSheet(doctor);

  await showCustomSideSheet(
    context: context,
    scrollable: false,
    child: Form(
      key: doctorsCubit.doctorFormKey,
      child: Column(
        children: [
          SectionTitle(title: title),
          verticalSpace(50),
          if (!newDoctor) _buildDoctorId(doctor.id),
          if (!newDoctor) verticalSpace(50),
          FieldsRow(
            fields: const [
              AppStrings.doctorName,
              AppStrings.speciality,
            ],
            firstText: doctor?.name ?? '',
            secondText: doctor?.speciality ?? '',
            enabled: editable,
            validations: const [true, false],
            onSaved: doctorsCubit.onSaveDoctorFormField,
          ),
          verticalSpace(50),
          FieldsRow(
            fields: const [
              AppStrings.phone,
              AppStrings.anotherPhoneNumber,
            ],
            firstText: doctor?.phone,
            secondText: doctor?.anotherPhone,
            enabled: editable,
            validations: const [true, false],
            onSaved: doctorsCubit.onSaveDoctorFormField,
            firstValidator: (value) {
              if (!value!.isPhoneNumber()) {
                return AppStrings.phoneNumberError.tr();
              }
              return null;
            },
          ),
          verticalSpace(50),
          FieldsRow(
            fields: const [
              AppStrings.email,
              AppStrings.address,
            ],
            firstText: doctor?.email,
            secondText: doctor?.address,
            enabled: editable,
            validations: const [false, false],
            onSaved: doctorsCubit.onSaveDoctorFormField,
          ),
          const Spacer(),
          _buildActionIfNeeded(context, newDoctor, editable),
        ],
      ),
    ),
  );
}

_buildActionIfNeeded(BuildContext context, bool newDoctor, bool editMode) {
  if (newDoctor) {
    return _buildNewAction(context);
  } else if (editMode) {
    return _buildUpdateAction(context);
  }
  return const SizedBox.shrink();
}

AppTextField _buildDoctorId(String doctorId) {
  return AppTextField(
    initialValue: doctorId,
    hint: AppStrings.doctorId.tr(),
    enabled: false,
    maxWidth: double.infinity,
    insideHint: false,
  );
}

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
    text: AppStrings.saveDoctor.tr(),
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<DoctorsCubit>().onSaveDoctor();
    },
  );
}

AppTextButton _buildUpdateAction(BuildContext context) {
  return AppTextButton(
    text: AppStrings.updateDoctor.tr(),
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<DoctorsCubit>().onUpdateDoctor();
    },
  );
}
