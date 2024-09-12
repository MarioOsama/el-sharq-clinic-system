import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceSummary extends StatelessWidget {
  const InvoiceSummary(
      {super.key, required this.total, required this.cubit, this.invoiceItem});

  final double total;
  final InvoicesCubit cubit;
  final InvoiceModel? invoiceItem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesCubit, InvoicesState>(
      bloc: cubit,
      buildWhen: (previous, current) => current is InvoiceConstruting,
      builder: (context, state) {
        final summaryMap = _calculateSummary(state);
        return Row(
          children: [
            Expanded(
              child: AppTextField(
                hint: 'Discount (LE)',
                initialValue: invoiceItem != null
                    ? invoiceItem!.discount.toString()
                    : '0',
                enabled: invoiceItem == null,
                numeric: true,
                onChanged: (value) {
                  if (value.isEmpty) {
                    value = '0';
                  }
                  cubit.updateDiscount(double.parse(value));
                },
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildSummaryItem('Total', summaryMap['Total']!, context),
                  _buildSummaryItem(
                      'Discount (%)', summaryMap['Discount (%)']!, context),
                  _buildSummaryItem('Total after discount',
                      summaryMap['Total after discount']!, context),
                  _buildSummaryItem('Number of items',
                      summaryMap['Number of items']!, context),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Row _buildSummaryItem(String title, num value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.font14DarkGreyMedium(context),
        ),
        Text(
          value.toStringAsFixed(2),
          style: AppTextStyles.font14DarkGreyMedium(context),
        ),
      ],
    );
  }

  Map<String, double> _calculateSummary(InvoicesState state) {
    final Map<String, double> summaryMap = {
      'Total': 0.0,
      'Discount (%)': 0.0,
      'Total after discount': 0.0,
      'Number of items': 0.0,
    };
    if (state is InvoiceConstruting) {
      summaryMap['Total'] = state.invoiceModel.total;
      summaryMap['Discount (%)'] = state.invoiceModel.discount == 0
          ? 0
          : state.invoiceModel.discount / state.invoiceModel.total * 100;

      summaryMap['Total after discount'] =
          state.invoiceModel.total - state.invoiceModel.discount;
      summaryMap['Number of items'] =
          state.invoiceModel.items.length.toDouble();
    }

    return summaryMap;
  }
}
