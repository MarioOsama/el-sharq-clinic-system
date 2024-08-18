import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_body.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_side_sheet.dart';
import 'package:flutter/material.dart';

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
          hintText: 'Search by name or phone',
          onChanged: (value) {
            // context.read<CaseHistoryCubit>().search(value);
          },
        ),

        SectionActionButton(
          newText: 'New Owner',
          onNewPressed: () => showOwnerSheet(context, 'New Owner'),
          onDeletePressed: () {},
          valueNotifier: ValueNotifier(false),
        ),
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: OwnersBody()),
          ],
        ),
      ),
    );
  }
}
