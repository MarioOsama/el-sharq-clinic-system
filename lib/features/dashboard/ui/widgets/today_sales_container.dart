import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/dashboard/data/models/pie_chart_item_model.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/sales_pie_chart.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/sales_pie_chart_keys.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/statistics_item_title.dart';
import 'package:flutter/material.dart';

class TodaySalesContainer extends StatelessWidget {
  const TodaySalesContainer(
      {super.key, required this.dataMap, required this.todayRevenue});

  final double todayRevenue;
  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: _buildBoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StatisticsItemTitle(title: 'Today\'s Sales'),
              verticalSpace(40),
              SalesPieChartKeys(
                colors: [
                  AppColors.red.withOpacity(0.9),
                  AppColors.blue.withOpacity(0.9),
                  AppColors.green.withOpacity(0.9),
                ],
                keys: dataMap.keys.toList(),
              ),
            ],
          ),
          SalesPieChart(
            items: _getPieChartItemsList(dataMap),
          ),
        ],
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

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.white,
      border: Border.all(
        color: AppColors.darkGrey.withOpacity(0.25),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.15),
          blurRadius: 3,
          spreadRadius: 2,
          offset: const Offset(2, 2),
        ),
      ],
    );
  }
}
