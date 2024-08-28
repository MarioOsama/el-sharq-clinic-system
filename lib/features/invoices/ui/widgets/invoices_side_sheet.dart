import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoice_side_sheet_items_column.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoice_new_item_buttons_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showInvoiceSheet(BuildContext context, String title,
    {bool editable = true}) async {
  final double height = MediaQuery.sizeOf(context).height;

  await showCustomSideSheet(
    context: context,
    child: Column(
      children: [
        SectionTitle(title: title),
        verticalSpace(50),
        _buildAddItemButtons(context, editable),
        verticalSpace(50),
        InvoiceSideSheetItemsColumn(
          editable: editable,
          itemsFormKeys: [GlobalKey<FormState>()],
          onSaved: (field, value, index) => null,
        ),
        verticalSpace(height * 0.4),
        _buildActionIfNeeded(context, true),
      ],
    ),
  );
}

InvoiceNewItemButtonsRow _buildAddItemButtons(
    BuildContext context, bool editable) {
  return InvoiceNewItemButtonsRow(
    onAddService: () {},
    onAddMedicine: () {},
    onAddAccessory: () {},
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
    onPressed: () {},
  );
}
