import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/side_sheet_pet_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showAddPetSheet(
    BuildContext context, String title, String ownerId) async {
  final OwnersCubit ownersCubit = context.read<OwnersCubit>();
  ownersCubit.setupNewSheet();

  await showCustomSideSheet(
    context: context,
    child: Column(
      children: [
        SectionTitle(title: title),
        verticalSpace(50),
        SideSheetPetContainer(
          editable: true,
          index: 0,
          petFormKey: ownersCubit.petFormsKeys[0],
          onSaved: (field, value) =>
              ownersCubit.onSavePetFormField(field, value, 0),
        ),
        verticalSpace(100),
        _buildAddAction(context, ownerId)
      ],
    ),
  );
}

AppTextButton _buildAddAction(BuildContext context, String ownerId) {
  return AppTextButton(
    text: 'Add Pet',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<OwnersCubit>().validateThenAddPet(ownerId);
    },
  );
}
