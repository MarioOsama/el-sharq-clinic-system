import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:flutter/material.dart';

class SideSheetPetContainer extends StatelessWidget {
  const SideSheetPetContainer({
    super.key,
    required this.editable,
    required this.index,
    required this.petFormKey,
    this.onSaved,
  });

  final int index;
  final bool editable;
  final GlobalKey<FormState> petFormKey;
  final void Function(String field, String? value)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pet $index',
          style: AppTextStyles.font16DarkGreyMedium
              .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: petFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  hint: 'Name',
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter a Name';
                    }
                    return null;
                  },
                  enabled: editable,
                  width: double.infinity,
                  insideHint: false,
                  onSaved: (value) {
                    if (onSaved != null) {
                      onSaved!('Name', value);
                    }
                  },
                ),
                verticalSpace(15),
                FieldsRow(
                  fields: const [
                    'Gender',
                    'Type',
                  ],
                  validations: const [false, false],
                  enabled: editable,
                  onSaved: onSaved,
                ),
                verticalSpace(15),
                FieldsRow(
                  fields: const [
                    'Age',
                    'Breed',
                  ],
                  validations: const [false, false],
                  enabled: editable,
                  onSaved: onSaved,
                ),
                verticalSpace(15),
                FieldsRow(
                  fields: const [
                    'Color',
                    'Weight',
                  ],
                  validations: const [false, false],
                  enabled: editable,
                  onSaved: onSaved,
                ),
                verticalSpace(15),
                FieldsRow(
                  fields: const [
                    'Vaccinations',
                    'Treatments',
                  ],
                  validations: const [false, false],
                  enabled: editable,
                  isMultiline: true,
                  onSaved: onSaved,
                ),
                verticalSpace(15),
                AppTextField(
                  hint: 'Pet Report',
                  initialValue: AppConstant.petProfileReportScheme,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please write a Pet Report';
                    }
                    return null;
                  },
                  enabled: editable,
                  width: double.infinity,
                  height: 175,
                  isMultiline: true,
                  insideHint: false,
                  onSaved: (value) {
                    if (onSaved != null) {
                      onSaved!('Pet Report', value);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
