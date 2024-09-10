import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/data/models/pie_chart_item_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesPieChart extends StatefulWidget {
  const SalesPieChart({super.key, required this.items});

  final List<PieChartItemModel> items;

  @override
  State<SalesPieChart> createState() => _SalesPieChartState();
}

class _SalesPieChartState extends State<SalesPieChart> {
  int touchedIndex = -1;

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
          centerSpaceRadius: 70.r,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.items.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 14.sp : 16.sp;
      final radius = isTouched ? 105.r : 85.r;
      final Color color = widget.items[i].color;
      final double value = widget.items[i].value;
      final String displayedValue = isTouched
          ? '${widget.items[i].value.toStringAsFixed(0)} LE'
          : '${widget.items[i].percentage.toStringAsFixed(1)}%';

      return PieChartSectionData(
        color: color,
        value: value,
        title: !isTouched && touchedIndex != -1 ? null : displayedValue,
        radius: radius,
        titleStyle: AppTextStyles.font20DarkGreyMedium.copyWith(
          color: isTouched ? AppColors.black : AppColors.white,
          fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
        ),
        titlePositionPercentageOffset: 0.5,
      );
    });
  }
}
