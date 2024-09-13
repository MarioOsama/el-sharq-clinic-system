import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/cases_bar_chart.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/dashboard_stats_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/statistics_item_title.dart';
import 'package:flutter/material.dart';

class CasesLastWeek extends StatelessWidget {
  const CasesLastWeek({super.key, required this.weeklyCases});

  final Map<String, int> weeklyCases;

  @override
  Widget build(BuildContext context) {
    return DashboardStatsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatisticsItemTitle(title: AppStrings.lastWeekCases.tr()),
          verticalSpace(40),
          CasesBarChart(
            weeklyCases: weeklyCases,
          ),
        ],
      ),
    );
  }
}
