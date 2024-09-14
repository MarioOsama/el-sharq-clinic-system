import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoice_side_sheet_item_container.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/invoice_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceSideSheetItemsColumn extends StatelessWidget {
  const InvoiceSideSheetItemsColumn({
    super.key,
    this.invoice,
    required this.editable,
    required this.cubitContext,
  });

  final bool editable;
  final InvoiceModel? invoice;
  final BuildContext cubitContext;

  @override
  Widget build(BuildContext context) {
    final cubit = cubitContext.read<InvoicesCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._getItems(cubit, context),
        verticalSpace(30),
        InvoiceSummary(
          total: cubit.invoiceInfo.total,
          cubit: cubit,
          invoiceItem: invoice,
        ),
      ],
    );
  }

  List<Widget> _getItems(InvoicesCubit cubit, BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    return List.generate(
      cubit.invoiceInfo.items.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Stack(
          children: [
            InvoiceSideSheetItemContainer(
              index: index + 1,
              itemFormKey: cubit.itemFormsKeys[index],
              editable: editable,
              cubitContext: cubitContext,
              invoiceItem: editable ? null : cubit.invoiceInfo.items[index],
            ),
            if (index != 0 && editable)
              _buildRemoveButton(index, cubit, locale),
          ],
        ),
      ),
    );
  }

  Positioned _buildRemoveButton(int index, InvoicesCubit cubit, Locale locale) {
    return Positioned(
      top: 25.h,
      right: locale.languageCode == 'en' ? 0 : null,
      left: locale.languageCode == 'en' ? null : 0,
      child: IconButton(
        hoverColor: Colors.transparent,
        icon: const Icon(
          Icons.cancel,
          color: AppColors.red,
          size: 30,
        ),
        onPressed: () => cubit.decrementItems(index),
      ),
    );
  }
}
