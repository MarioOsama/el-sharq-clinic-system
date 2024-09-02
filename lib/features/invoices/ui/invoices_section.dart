import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_bloc_listener.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_body.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_side_sheet.dart';
import 'package:flutter/material.dart';

class InvoicesSection extends StatelessWidget {
  const InvoicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'Invoices',
      actions: [
        SectionActionButton(
          newText: 'New Invoice',
          onNewPressed: () => showInvoiceSheet(context, 'New Invoice'),
          onDeletePressed: () {},
          valueNotifier: ValueNotifier(false),
        ),
      ],
      child: Expanded(
        child: Column(
          children: [
            verticalSpace(50),
            const Expanded(child: InvoicesBody()),
            const InvoicesBlocListener(),
          ],
        ),
      ),
    );
  }
}
