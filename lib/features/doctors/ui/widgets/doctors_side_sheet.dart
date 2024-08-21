import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showDoctorSheet(BuildContext context, String title,
    {bool editable = true}) async {
  await showCustomSideSheet(
    context: context,
    scrollable: false,
    child: Column(
      children: [
        SectionTitle(title: title),
        verticalSpace(50),
        // _buildDoctorId(),
        // verticalSpace(50),
        FieldsRow(
          fields: const [
            'Doctor Name',
            'Speciality',
          ],
          firstController: TextEditingController(),
          secondController: TextEditingController(),
          enabled: editable,
        ),
        verticalSpace(50),
        FieldsRow(
          fields: const [
            'Phone Number',
            'Another Phone Number',
          ],
          firstController: TextEditingController(),
          secondController: TextEditingController(),
          enabled: editable,
        ),
        verticalSpace(50),
        FieldsRow(
          fields: const [
            'Email',
            'Address',
          ],
          firstController: TextEditingController(),
          secondController: TextEditingController(),
          enabled: editable,
        ),
        const Spacer(),
        _buildActionIfNeeded(context, true, editable),
      ],
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

AppTextField _buildDoctorId(TextEditingController idController) {
  return AppTextField(
    controller: idController,
    hint: 'Doctor ID',
    enabled: false,
    maxWidth: double.infinity,
    insideHint: false,
  );
}

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
    text: 'Save Doctor',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {},
  );
}

AppTextButton _buildUpdateAction(BuildContext context) {
  return AppTextButton(
    text: 'Update Doctor',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {},
  );
}
