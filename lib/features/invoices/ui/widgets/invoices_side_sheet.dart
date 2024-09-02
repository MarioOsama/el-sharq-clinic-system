import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoice_side_sheet_items_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showInvoiceSheet(BuildContext context, String title,
    {InvoiceModel? invoice, bool editable = true}) async {
  final double height = MediaQuery.sizeOf(context).height;

  final bool newInvoice = invoice == null;
  final InvoicesCubit invoicesCubit = context.read<InvoicesCubit>();

  newInvoice
      ? invoicesCubit.setupNewSheet()
      : invoicesCubit.setupExistingSheet(invoice);

  await showCustomSideSheet(
    context: context,
    child: Column(
      children: [
        SectionTitle(title: title),
        verticalSpace(50),
        _buildAddItemButtons(context, editable),
        verticalSpace(50),
        BlocBuilder<InvoicesCubit, InvoicesState>(
          bloc: invoicesCubit,
          buildWhen: (previous, current) => current is InvoiceConstruting,
          builder: (_, state) {
            return InvoiceSideSheetItemsColumn(
              editable: editable,
              invoice: invoice,
              cubitContext: context,
            );
          },
        ),
        verticalSpace(height * 0.25),
        _buildActionIfNeeded(context, newInvoice),
      ],
    ),
  );
}

AppTextButton _buildAddItemButtons(BuildContext context, bool editable) {
  return AppTextButton(
    text: 'Add Item',
    width: MediaQuery.sizeOf(context).width,
    onPressed: () => context.read<InvoicesCubit>().incrementItems(),
    height: 70.h,
  );
}

_buildActionIfNeeded(BuildContext context, bool newInvoice) {
  if (newInvoice) {
    return _buildNewAction(context);
  }
  return const SizedBox.shrink();
}

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
      text: 'Save Invoice',
      width: MediaQuery.sizeOf(context).width,
      height: 70.h,
      onPressed: () => context.read<InvoicesCubit>().onSaveNewInvoice());
}
