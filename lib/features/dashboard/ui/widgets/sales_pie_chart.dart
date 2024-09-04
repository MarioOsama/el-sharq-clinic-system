import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesPieChart extends StatefulWidget {
  const SalesPieChart({super.key});

  @override
  State<SalesPieChart> createState() => _SalesPieChartState();
}

class _SalesPieChartState extends State<SalesPieChart> {
  int touchedIndex = -1;

  final colorsList = [
    AppColors.red,
    AppColors.blue,
    AppColors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          sectionsSpace: 3,
          centerSpaceRadius: 60,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(colorsList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.sp : 16.sp;
      final radius = isTouched ? 90.r : 70.r;

      return PieChartSectionData(
        color: colorsList[i].withOpacity(0.85),
        value: i == 0 ? 60 : 20,
        title: i == 0 ? '60%' : '20%',
        radius: radius,
        titleStyle: AppTextStyles.font20DarkGreyMedium.copyWith(
          color: isTouched ? AppColors.white : AppColors.black,
          fontSize: fontSize,
        ),
        titlePositionPercentageOffset: 0.55,
      );
    });
  }
}
