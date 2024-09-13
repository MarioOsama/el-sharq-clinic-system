import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/add_pet_side_sheet.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnersRowActionButton extends StatelessWidget {
  const OwnersRowActionButton({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: 'Edit',
            onTap: () {
              showOwnerSheet(context, AppStrings.ownerDetails.tr(),
                  editable: true,
                  ownerModel: context.read<OwnersCubit>().getOwnerById(id));
            },
            child: Text(
              AppStrings.edit.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
          PopupMenuItem(
            value: 'Add Pet',
            onTap: () {
              showAddPetSheet(context, AppStrings.addPet.tr(), id);
            },
            child: Text(
              AppStrings.addPet.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            onTap: () {
              showDialog(
                context: ctx,
                builder: (_) => AppAlertDialog(
                  alertMessage: AppStrings.deleteOwnerMessage.tr(),
                  onConfirm: () {
                    context.read<OwnersCubit>().onDeleteOwner(id);
                    ctx.pop();
                  },
                  onCancel: () {
                    ctx.pop();
                  },
                ),
              );
            },
            child: Text(
              AppStrings.delete.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
        ];
      },
    );
  }
}
