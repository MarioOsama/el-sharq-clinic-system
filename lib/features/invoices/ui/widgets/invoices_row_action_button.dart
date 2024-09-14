import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/password_dialog.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoicesRowActionButton extends StatelessWidget {
  const InvoicesRowActionButton({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: 'Print',
            onTap: () {
              context.read<InvoicesCubit>().onPrintInvoice(id);
            },
            child: Text(
              AppStrings.print.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            onTap: () {
              showDialog(
                context: ctx,
                builder: (_) => AppAlertDialog(
                  alertMessage: AppStrings.deleteInvoiceConfirmationSingle.tr(),
                  onConfirm: () {
                    // Show dialog to confirm deleting process and ask user for clinic password to delete
                    ctx.pop();
                    showDialog(
                      context: context,
                      builder: (ctx) => PasswordDialog(
                        title: AppStrings.enterAdminPassword.tr(),
                        actionTitle: AppStrings.confirmDelete.tr(),
                        onActionPressed: (password) {
                          context
                              .read<InvoicesCubit>()
                              .onDeleteInvoice(id, password);
                        },
                      ),
                    );
                  },
                  onCancel: () {
                    ctx.pop();
                  },
                ),
              );
            },
            child: Text(
              AppStrings.delete.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
        ];
      },
    );
  }
}
