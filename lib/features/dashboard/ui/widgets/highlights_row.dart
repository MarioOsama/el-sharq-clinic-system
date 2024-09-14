import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/overview_item.dart';
import 'package:flutter/material.dart';

class TodayHighlightsRow extends StatelessWidget {
  const TodayHighlightsRow({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _getOverviewItems(overviewItemsList),
    );
  }

  List<Widget> _getOverviewItems(List<Widget> overviewItems) {
    return List.generate(4, (index) {
      return overviewItems[index];
    });
  }

  List<Widget> _getItemsList() {
    return [
      FadeInUp(
        child: OverviewItem(
          title: AppStrings.cases.tr(),
          value: cases.toDouble(),
          iconData: Icons.pets,
        ),
      ),
      FadeInDown(
        child: OverviewItem(
          title: AppStrings.owners.tr(),
          value: owners.toDouble(),
          iconData: Icons.person,
        ),
      ),
      FadeInUp(
        child: OverviewItem(
          title: AppStrings.invoices.tr(),
          value: invoices.toDouble(),
          iconData: Icons.receipt_long,
        ),
      ),
      FadeInDown(
        child: OverviewItem(
          title: AppStrings.revenue.tr(),
          value: revenue,
          iconData: Icons.monetization_on,
          decimals: 1,
        ),
      ),
    ];
  }
}
