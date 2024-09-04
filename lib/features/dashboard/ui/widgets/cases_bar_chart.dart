import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _BarChart extends StatefulWidget {
  const _BarChart();

  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
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
              AppTextStyles.font14DarkGreyMedium.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getLeftTitles(double value, TitleMeta meta) {
    final style = AppTextStyles.font14DarkGreyMedium.copyWith(
      color: AppColors.blue,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 10:
        text = '10';
        break;
      case 20:
        text = '20';
        break;
      default:
        return Container();
    }
    return Text(text, style: style);
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = AppTextStyles.font14DarkGreyMedium.copyWith(
      color: AppColors.blue,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
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
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getLeftTitles,
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

  List<BarChartGroupData> get barGroups {
    final BackgroundBarChartRodData backgroundBarChartRodData =
        BackgroundBarChartRodData(
      show: true,
      toY: 20,
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

    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            width: 30,
            backDrawRodData:
                touchedIndex == 0 ? backgroundBarChartRodData : null,
            toY: 8,
            color: AppColors.blue.withOpacity(0.85),
            borderRadius: touchedIndex == 0 ? BorderRadius.circular(10) : null,
            gradient: touchedIndex == 0 ? gradient : null,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            width: 30,
            backDrawRodData:
                touchedIndex == 1 ? backgroundBarChartRodData : null,
            toY: 10,
            color: AppColors.blue.withOpacity(0.85),
            borderRadius: touchedIndex == 1 ? BorderRadius.circular(10) : null,
            gradient: touchedIndex == 1 ? gradient : null,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            width: 30,
            backDrawRodData:
                touchedIndex == 2 ? backgroundBarChartRodData : null,
            toY: 14,
            color: AppColors.blue.withOpacity(0.9),
            borderRadius: touchedIndex == 2 ? BorderRadius.circular(10) : null,
            gradient: touchedIndex == 2 ? gradient : null,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            width: 30,
            backDrawRodData:
                touchedIndex == 3 ? backgroundBarChartRodData : null,
            toY: 15,
            color: AppColors.blue.withOpacity(0.85),
            borderRadius: touchedIndex == 3 ? BorderRadius.circular(10) : null,
            gradient: touchedIndex == 3 ? gradient : null,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            width: 30,
            backDrawRodData:
                touchedIndex == 4 ? backgroundBarChartRodData : null,
            toY: 13,
            color: AppColors.blue.withOpacity(0.85),
            borderRadius: touchedIndex == 4 ? BorderRadius.circular(10) : null,
            gradient: touchedIndex == 4 ? gradient : null,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(
            width: 30,
            backDrawRodData:
                touchedIndex == 5 ? backgroundBarChartRodData : null,
            toY: 10,
            color: AppColors.blue.withOpacity(0.85),
            borderRadius: touchedIndex == 5 ? BorderRadius.circular(10) : null,
            gradient: touchedIndex == 5 ? gradient : null,
          )
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 6,
        barRods: [
          BarChartRodData(
            width: 30,
            backDrawRodData:
                touchedIndex == 6 ? backgroundBarChartRodData : null,
            toY: 16,
            color: AppColors.blue.withOpacity(0.85),
            borderRadius: touchedIndex == 6 ? BorderRadius.circular(10) : null,
            gradient: touchedIndex == 6 ? gradient : null,
          )
        ],
        showingTooltipIndicators: [0],
      ),
    ];
  }
}

class CasesBarChart extends StatefulWidget {
  const CasesBarChart({super.key});

  @override
  State<CasesBarChart> createState() => _CasesBarChartState();
}

class _CasesBarChartState extends State<CasesBarChart> {
  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 2.8,
      child: _BarChart(),
    );
  }
}
