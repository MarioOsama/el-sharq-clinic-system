import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CasesBarChart extends StatefulWidget {
  final Map<String, int> weeklyCases;

  const CasesBarChart({super.key, required this.weeklyCases});

  @override
  State<CasesBarChart> createState() => CasesBarChartState();
}

class CasesBarChartState extends State<CasesBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.8,
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData(context),
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
          maxY: maxY,
        ),
      ),
    );
  }

  BarTouchData barTouchData(BuildContext context) => BarTouchData(
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }

            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 4,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              AppTextStyles.font14DarkGreyMedium(context).copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = AppTextStyles.font14DarkGreyMedium(context).copyWith(
      color: AppColors.blue,
      fontWeight: FontWeight.bold,
    );

    List<String> days = widget.weeklyCases.keys.toList();
    String text = days[value.toInt()];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text.substring(0, 3), style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  double get maxY =>
      (widget.weeklyCases.values.reduce((a, b) => a > b ? a : b) * 1.1)
          .toDouble();

  List<BarChartGroupData> get barGroups {
    final BackgroundBarChartRodData backgroundBarChartRodData =
        BackgroundBarChartRodData(
      show: true,
      toY: maxY,
      fromY: 0,
      color: AppColors.blue.withOpacity(0.25),
    );

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        AppColors.blue.withOpacity(0.85),
        AppColors.blue.withOpacity(0.02),
      ],
    );

    return widget.weeklyCases.entries.map((entry) {
      int index = widget.weeklyCases.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            width: 40,
            backDrawRodData:
                touchedIndex == index ? backgroundBarChartRodData : null,
            toY: entry.value.toDouble(),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.blue.withOpacity(0.85),
            gradient: touchedIndex == index ? gradient : null,
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }
}
