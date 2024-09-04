import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/highlights_row.dart';
import 'package:flutter/material.dart';

class TodayOverview extends StatelessWidget {
  const TodayOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Toady Overview',
          style: AppTextStyles.font22DarkGreyMedium,
        ),
        verticalSpace(40),
        const TodayHighlightsRow(),
      ],
    );
  }
}
