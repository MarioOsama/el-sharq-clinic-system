import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/fields_row.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/owner_model.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/side_sheet_owner_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showOwnerSheet(BuildContext context, String title,
    {OwnerModel? ownerModel, bool editable = true}) async {
  final bool newOwner = ownerModel == null;
  // final OwnersCubit OwnersCubit = context.read<OwnersCubit>();
  // newCase
  //     ? OwnersCubit.setupNewModeControllers()
  //     : OwnersCubit.setupShowModeControllers(caseHistoryModel);

  await showCustomSideSheet(
    context: context,
    child: Column(
      children: [
        SectionTitle(title: title),
        verticalSpace(50),
        if (newOwner) _buildAddPetButton(context),
        if (!newOwner) _buildOwnerId(context),
        verticalSpace(50),
        SideSheetOwnerContainer(
          editable: editable,
        ),
        verticalSpace(50),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pet 1',
              style: AppTextStyles.font16DarkGreyMedium
                  .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    hint: 'Name',
                    enabled: editable,
                    width: double.infinity,
                    insideHint: false,
                  ),
                  verticalSpace(15),
                  FieldsRow(
                    fields: const [
                      'Gender',
                      'Type',
                    ],
                    enabled: editable,
                  ),
                  verticalSpace(15),
                  FieldsRow(
                    fields: const [
                      'Age',
                      'Breed',
                    ],
                    enabled: editable,
                  ),
                  verticalSpace(15),
                  FieldsRow(
                    fields: const [
                      'Vaccination',
                      'Treatments',
                    ],
                    enabled: editable,
                    isMultiline: true,
                  ),
                  verticalSpace(15),
                  AppTextField(
                    hint: 'Pet Report',
                    enabled: editable,
                    width: double.infinity,
                    height: 150,
                    isMultiline: true,
                    insideHint: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpace(100),
        _buildActionIfNeeded(context, newOwner, editable),
      ],
    ),
  );
}

_buildAddPetButton(BuildContext context) {
  return AppTextButton(
    text: 'Add Pet',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {},
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

AppTextField _buildOwnerId(BuildContext context) {
  return AppTextField(
    hint: 'Owner ID',
    enabled: false,
    width: double.infinity,
    insideHint: false,
  );
}

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
    text: 'Save Owner',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {},
  );
}

AppTextButton _buildUpdateAction(BuildContext context) {
  return AppTextButton(
    text: 'Update Owner',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {},
  );
}
