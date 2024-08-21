import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
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
      title: 'Owners',
      actions: [
        // Search bar
        SectionSearchBar(
          hintText: 'Search by phone number',
          onChanged: (value) {
            context.read<OwnersCubit>().onSearch(value);
          },
        ),

        SectionActionButton(
          newText: 'New Owner',
          onNewPressed: () => showOwnerSheet(context, 'New Owner'),
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
        alertMessage: 'Are you sure you want to delete these owner profiles?\n'
            'This action cannot be undone.',
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
