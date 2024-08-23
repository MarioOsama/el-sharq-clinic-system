import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_body.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_side_sheet.dart';
import 'package:flutter/material.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'Services',
      actions: [
        // Search bar
        SectionSearchBar(
          hintText: 'Search by service name',
          onChanged: (value) {},
        ),
        SectionActionButton(
          newText: 'New Services',
          onNewPressed: () {
            showServiceSheet(context, 'New Service');
          },
        ),
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: ServicesBody()),
            //TODO: add bloc listener
          ],
        ),
      ),
    );
  }
}
