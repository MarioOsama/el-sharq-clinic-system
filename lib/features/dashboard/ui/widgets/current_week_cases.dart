import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/cases_bar_chart.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/dashboard_stats_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/statistics_item_title.dart';
import 'package:flutter/material.dart';

class CurrentWeekCases extends StatelessWidget {
  const CurrentWeekCases({super.key, required this.weeklyCases, this.barWidth});

  final Map<String, int> weeklyCases;
  final double? barWidth;

  @override
  Widget build(BuildContext context) {
    return DashboardStatsContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 24.0, top: 20),
            child: StatisticsItemTitle(title: AppStrings.currentWeekCases.tr()),
          ),
          verticalSpace(40),
          CasesBarChart(
            weeklyCases: weeklyCases,
            barWidth: barWidth,
          ),
        ],
      ),
    );
  }
}
