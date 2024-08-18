import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/owner_model.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/side_sheet_owner_container.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/side_sheet_pets_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showOwnerSheet(BuildContext context, String title,
    {OwnerModel? ownerModel, bool editable = true}) async {
  final bool newOwner = ownerModel == null;
  final OwnersCubit ownersCubit = context.read<OwnersCubit>();
  ownersCubit.setupNewSheet();
  // newOwner
  //     ? OwnersCubit.setupNewModeControllers()
  //     : OwnersCubit.setupShowModeControllers(caseHistoryModel);

  await showCustomSideSheet(
    context: context,
    child: Column(
      children: [
        SectionTitle(title: title),
        verticalSpace(50),
        if (newOwner) _buildAddPetButton(context, ownersCubit),
        if (!newOwner) _buildOwnerId(context),
        verticalSpace(50),
        SideSheetOwnerContainer(
          editable: editable,
          ownerFormKey: ownersCubit.ownerFormKey,
        ),
        verticalSpace(50),
        SideSheetPetsColumn(
          editable: editable,
          petsNumberNotifier: ownersCubit.numberOfPetsNotifier,
          petFormsKeys: ownersCubit.petFormsKeys,
          onDecrementPets: (index) => ownersCubit.decrementPets(index),
        ),
        verticalSpace(100),
        _buildActionIfNeeded(context, newOwner, editable),
      ],
    ),
  );
}

_buildAddPetButton(BuildContext context, OwnersCubit ownersCubit) {
  return AppTextButton(
    text: 'Add Pet',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () => ownersCubit.incrementPets(),
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
  return const AppTextField(
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
    onPressed: () {
      context.read<OwnersCubit>().validateThenSave();
    },
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
