import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_bloc_listener.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_body.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnersSection extends StatelessWidget {
  const OwnersSection({super.key, required this.authData});

  final AuthDataModel authData;

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: AppStrings.owners.tr(),
      actions: [
        // Search bar
        SectionSearchBar(
          hintText: AppStrings.ownersSearchText.tr(),
          onChanged: (value) {
            context.read<OwnersCubit>().onSearch(value);
          },
        ),

        SectionActionButton(
          newText: AppStrings.newOwner.tr(),
          onNewPressed: () => showOwnerSheet(context, AppStrings.newOwner.tr()),
          onDeletePressed: () => _onDeleteOwner(context),
          valueNotifier: context.read<OwnersCubit>().showDeleteButtonNotifier,
        ),
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: OwnersBody()),
            const OwnersBlocListener(),
          ],
        ),
      ),
    );
  }

  void _onDeleteOwner(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppAlertDialog(
        alertMessage: AppStrings.deleteOwnerMessage.tr(),
        onConfirm: () {
          context.read<OwnersCubit>().onDeleteSelectedOwners();
          context.pop();
        },
        onCancel: () {
          context.pop();
        },
      ),
    );
  }
}
