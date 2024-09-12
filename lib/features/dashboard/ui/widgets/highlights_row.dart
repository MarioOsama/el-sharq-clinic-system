import 'package:animate_do/animate_do.dart';
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
          title: 'Cases',
          value: cases.toDouble(),
          iconData: Icons.pets,
        ),
      ),
      FadeInDown(
        child: OverviewItem(
          title: 'Owners',
          value: owners.toDouble(),
          iconData: Icons.person,
        ),
      ),
      FadeInUp(
        child: OverviewItem(
          title: 'Invoices',
          value: invoices.toDouble(),
          iconData: Icons.receipt_long,
        ),
      ),
      FadeInDown(
        child: OverviewItem(
          title: 'Revenue',
          value: revenue,
          iconData: Icons.monetization_on,
          decimals: 2,
        ),
      ),
    ];
  }
}
