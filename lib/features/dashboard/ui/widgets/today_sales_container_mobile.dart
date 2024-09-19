import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/data/models/pie_chart_item_model.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/dashboard_stats_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/sales_pie_chart.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/sales_pie_chart_keys.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/statistics_item_title.dart';
import 'package:flutter/material.dart';

class MobileTodaySalesContainer extends StatelessWidget {
  const MobileTodaySalesContainer({
    super.key,
    required this.dataMap,
    required this.todayRevenue,
  });

  final double todayRevenue;
  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    final pieChartData = _getPieChartItemsList(dataMap);
    final List<Color> colorsList = dataMap.keys
        .map((e) => (AppConstant.dashboardSalesSectionsColorList[
                dataMap.keys.toList().indexOf(e)])
            .withOpacity(0.9))
        .toList();
    return DashboardStatsContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: pieChartData.isEmpty
          ? _buildNoSalesText(context)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  child: StatisticsItemTitle(title: AppStrings.todaySales.tr()),
                ),
                verticalSpace(10),
                pieChartData.isEmpty
                    ? _buildNoSalesText(context)
                    : SalesPieChart(
                        items: pieChartData,
                      ),
                SalesPieChartKeys(
                  isHorizontal: true,
                  colors: colorsList,
                  keys: dataMap.keys.toList(),
                ),
                verticalSpace(10),
              ],
            ),
    );
  }

  AspectRatio _buildNoSalesText(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Center(
        child: Text(AppStrings.noSalesToday.tr(),
            style: AppTextStyles.font22DarkGreyMedium(context)),
      ),
    );
  }

  List<PieChartItemModel> _getPieChartItemsList(Map<String, double> dataMap) {
    if (dataMap.values.every((value) => value == 0)) {
      return [];
    }
    final List<Color> colors = [
      AppColors.red.withOpacity(0.9),
      AppColors.blue.withOpacity(0.9),
      AppColors.green.withOpacity(0.9),
    ];
    final List<PieChartItemModel> items = [];
    dataMap.forEach((category, amount) {
      items.add(PieChartItemModel(
        color: colors[items.length],
        value: amount,
        percentage: amount / todayRevenue * 100,
      ));
    });
    return items;
  }
}
