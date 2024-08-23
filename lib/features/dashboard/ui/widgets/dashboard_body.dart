import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/custom_time_line.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/highlights_row.dart';
import 'package:flutter/material.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Highlights',
            style: AppTextStyles.font20DarkGreyMedium,
          ),
          verticalSpace(40),
          const HighlightsRow(),
          verticalSpace(100),
          const Text(
            'Timeline',
            style: AppTextStyles.font20DarkGreyMedium,
          ),
          const SizedBox(
            height: 180,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CustomTimeLine(
                timesList: [
                  '6:00',
                  '12:00',
                  '13:20',
                  '14:00',
                  '24:00',
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
