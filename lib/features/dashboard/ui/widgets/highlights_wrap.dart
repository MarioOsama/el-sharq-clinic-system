import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/overview_item_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayHighlightsWrap extends StatelessWidget {
  const TodayHighlightsWrap({
    super.key,
    required this.cases,
    required this.owners,
    required this.invoices,
    required this.revenue,
  });

  final int cases;
  final int owners;
  final int invoices;
  final double revenue;

  @override
  Widget build(BuildContext context) {
    final overviewItemsList = _getItemsList();
    return Wrap(
      runSpacing: 20.h,
      spacing: 20.w,
      alignment: WrapAlignment.center,
      children: _getOverviewItems(overviewItemsList),
    );
  }

  List<Widget> _getOverviewItems(List<Widget> overviewItems) {
    return List.generate(4, (index) {
      return overviewItems[index];
    });
  }

  List<Widget> _getItemsList() {
    const double itemWidth = 170;
    const double itemHeight = 150;
    const double iconSize = 30;
    const EdgeInsets padding = EdgeInsets.all(20);

    return [
      FadeInUp(
        child: MobileOverviewItem(
          title: AppStrings.cases.tr(),
          value: cases.toDouble(),
          iconData: Icons.pets,
          width: itemWidth,
          height: itemHeight,
          iconSize: iconSize,
          padding: padding,
        ),
      ),
      FadeInDown(
        child: MobileOverviewItem(
          title: AppStrings.owners.tr(),
          value: owners.toDouble(),
          iconData: Icons.person,
          width: itemWidth,
          height: itemHeight,
          iconSize: iconSize,
          padding: padding,
        ),
      ),
      FadeInUp(
        child: MobileOverviewItem(
          title: AppStrings.invoices.tr(),
          value: invoices.toDouble(),
          iconData: Icons.receipt_long,
          width: itemWidth,
          height: itemHeight,
          iconSize: iconSize,
          padding: padding,
        ),
      ),
      FadeInDown(
        child: MobileOverviewItem(
          title: AppStrings.revenue.tr(),
          value: revenue,
          iconData: Icons.monetization_on,
          width: itemWidth,
          height: itemHeight,
          iconSize: iconSize,
          padding: padding,
          decimals: 1,
        ),
      ),
    ];
  }
}
