import 'package:el_sharq_clinic/features/dashboard/ui/widgets/overview_item.dart';
import 'package:flutter/material.dart';

class TodayHighlightsRow extends StatelessWidget {
  const TodayHighlightsRow({
    super.key,
  });

  final List<Widget> overviewItems = const [
    OverviewItem(
      title: 'Cases',
      value: '14',
      iconData: Icons.pets,
    ),
    OverviewItem(
      title: 'Owners',
      value: '8',
      iconData: Icons.person,
    ),
    OverviewItem(
      title: 'Invoices',
      value: '9',
      iconData: Icons.receipt_long,
    ),
    OverviewItem(
      title: 'Revenue',
      value: '1800000',
      iconData: Icons.monetization_on,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _getOverviewItems(context),
    );
  }

  List<Widget> _getOverviewItems(BuildContext context) {
    return List.generate(4, (index) {
      return overviewItems[index];
    });
  }
}
