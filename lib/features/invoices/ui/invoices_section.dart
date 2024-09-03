import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/password_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_bloc_listener.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_body.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoices_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoicesSection extends StatelessWidget {
  const InvoicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'Invoices',
      actions: [
        BlocBuilder<InvoicesCubit, InvoicesState>(
          builder: (context, state) {
            if (state is InvoicesLoading) {
              return const SizedBox.shrink();
            }
            return SectionActionButton(
              newText: 'New Invoice',
              onNewPressed: () => showInvoiceSheet(context, 'New Invoice'),
              onDeletePressed: () => _onDeleteDoctors(context),
              valueNotifier:
                  context.read<InvoicesCubit>().showDeleteButtonNotifier,
            );
          },
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

  void _onDeleteDoctors(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppAlertDialog(
        alertMessage: 'Are you sure you want to delete these doctor profiles?\n'
            'This action cannot be undone.',
        onConfirm: () {
          context.pop();
          showDialog(
            context: context,
            builder: (ctx) => PasswordDialog(
              actionTitle: 'Confirm Delete',
              onActionPressed: (password) {
                context
                    .read<InvoicesCubit>()
                    .onDeleteSelectedInvoices(password);
              },
            ),
          );
        },
        onCancel: () {
          context.pop();
        },
      ),
    );
  }
}
