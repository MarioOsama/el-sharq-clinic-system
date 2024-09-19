import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/dashboard_stats_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MobileOverviewItem extends StatelessWidget {
  const MobileOverviewItem({
    super.key,
    required this.title,
    required this.value,
    required this.iconData,
    this.decimals = 0,
    this.height,
    this.width,
    this.iconSize,
    this.padding,
  });

  final String title;
  final double value;
  final IconData iconData;
  final int? decimals;
  final double? height;
  final double? width;
  final double? iconSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return DashboardStatsContainer(
      height: height ?? 150.h,
      width: width ?? 280.w,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                iconData,
                size: 25,
                color: AppColors.darkGrey,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: AppTextStyles.font18DarkGreyMedium(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value.toStringAsFixed(decimals!),
                style: AppTextStyles.font32DarkGreyMedium(context).copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
