import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/overview_item.dart';
import 'package:flutter/material.dart';

class HighlightsRow extends StatelessWidget {
  const HighlightsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(child: OverviewItem(title: 'CaseHistory', value: '5')),
        Flexible(child: horizontalSpace(100)),
        const Expanded(child: OverviewItem(title: 'Sales', value: '34')),
        Flexible(child: horizontalSpace(100)),
        const Expanded(child: OverviewItem(title: 'Invoices', value: '15')),
      ],
    );
  }
}
