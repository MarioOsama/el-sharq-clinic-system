import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesPieChartKeys extends StatelessWidget {
  const SalesPieChartKeys(
      {super.key, required this.colors, required this.keys});

  final List<Color> colors;
  final List<String> keys;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildKeyItems(context));
  }

  List<Widget> _buildKeyItems(BuildContext context) {
    if (keys.length != colors.length) {
      throw Exception('Keys and colors length must be the same');
    }

    return List.generate(
      keys.length,
      (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 15.h),
          child: Row(
            children: [
              Container(
                height: 20.h,
                width: 15.w,
                decoration: BoxDecoration(
                  color: colors[index].withOpacity(0.85),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              horizontalSpace(10),
              Text(
                keys[index],
                style: AppTextStyles.font16DarkGreyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
