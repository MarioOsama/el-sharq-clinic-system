import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/highlights_row.dart';
import 'package:flutter/material.dart';

class TodayOverview extends StatelessWidget {
  const TodayOverview({super.key, required this.state});

  final DashboardSuccess state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Toady Overview',
          style: AppTextStyles.font22DarkGreyMedium(context),
        ),
        verticalSpace(40),
        TodayHighlightsRow(
          cases: state.todayCasesCount,
          owners: state.todayOwnersCount,
          invoices: state.todayInvoicesCount,
          revenue: state.todayRevenue,
        ),
      ],
    );
  }
}
