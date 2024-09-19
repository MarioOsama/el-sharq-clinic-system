import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/dashboard_body_mobile.dart';
import 'package:flutter/material.dart';

class MobileDashboardSection extends StatelessWidget {
  const MobileDashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20),
      title: AppStrings.dashboard.tr(),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(20),
            const Expanded(child: MobileDashboardBody()),
          ],
        ),
      ),
    );
  }
}
