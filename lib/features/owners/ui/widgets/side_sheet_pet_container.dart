import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/pet_model.dart';
import 'package:flutter/material.dart';

class SideSheetPetContainer extends StatelessWidget {
  const SideSheetPetContainer({
    super.key,
    required this.editable,
    required this.index,
    required this.petFormKey,
    this.onSaved,
    this.petModel,
  });

  final int index;
  final bool editable;
  final GlobalKey<FormState> petFormKey;
  final PetModel? petModel;
  final void Function(String field, String? value)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          index != 0
              ? '${AppStrings.pet.tr()} $index'
              : AppStrings.petDetails.tr(),
          style: AppTextStyles.font16DarkGreyMedium(context)
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
                  hint: AppStrings.name.tr(),
                  initialValue: petModel?.name,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return AppStrings.pleaseEnterName.tr();
                    }
                    return null;
                  },
                  enabled: editable,
                  maxWidth: double.infinity,
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
                    AppStrings.gender,
                    AppStrings.type,
                  ],
                  validations: const [false, false],
                  enabled: editable,
                  onSaved: onSaved,
                  firstText: petModel?.gender,
                  secondText: petModel?.type,
                ),
                verticalSpace(15),
                FieldsRow(
                  fields: const [
                    AppStrings.age,
                    AppStrings.breed,
                  ],
                  validations: const [false, false],
                  enabled: editable,
                  onSaved: onSaved,
                  firstText: petModel?.age.toString(),
                  secondText: petModel?.breed,
                ),
                verticalSpace(15),
                FieldsRow(
                  fields: const [
                    AppStrings.color,
                    AppStrings.weight,
                  ],
                  validations: const [false, false],
                  enabled: editable,
                  onSaved: onSaved,
                  firstText: petModel?.color,
                  secondText: petModel?.weight.toString(),
                ),
                verticalSpace(15),
                AppTextField(
                  hint: AppStrings.vaccinations.tr(),
                  initialValue: petModel?.vaccinations,
                  enabled: editable,
                  maxWidth: double.infinity,
                  isMultiline: true,
                  insideHint: false,
                  onSaved: (value) {
                    if (onSaved != null) {
                      onSaved!('Vaccinations', value);
                    }
                  },
                ),
                verticalSpace(15),
                AppTextField(
                  hint: AppStrings.treatments.tr(),
                  initialValue: petModel?.treatments,
                  enabled: editable,
                  maxWidth: double.infinity,
                  isMultiline: true,
                  insideHint: false,
                  onSaved: (value) {
                    if (onSaved != null) {
                      onSaved!('Treatments', value);
                    }
                  },
                ),
                verticalSpace(15),
                AppTextField(
                  hint: AppStrings.petReport.tr(),
                  initialValue: petModel != null
                      ? petModel!.petReport
                      : AppConstant.petProfileReportScheme,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return AppStrings.pleaseWritePetReport.tr();
                    }
                    return null;
                  },
                  enabled: editable,
                  maxWidth: double.infinity,
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
