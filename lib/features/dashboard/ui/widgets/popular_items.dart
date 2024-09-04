import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/statistics_item_title.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';
import 'package:flutter/material.dart';

class PopularItems extends StatelessWidget {
  const PopularItems({super.key, required this.items});

  final List<InvoiceItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatisticsItemTitle(title: 'Popular Items Last Week'),
          verticalSpace(20),
          _buildHeaderRow(),
          Divider(
            color: AppColors.darkGrey.withOpacity(0.25),
          ),
          AspectRatio(
            aspectRatio: 3.5,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _getItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Row _buildHeaderRow() {
    return const Row(
      children: [
        Text(
          'Item',
          style: AppTextStyles.font16DarkGreyMedium,
        ),
        Spacer(),
        Text(
          'Info',
          style: AppTextStyles.font16DarkGreyMedium,
        ),
      ],
    );
  }

  Widget _getItem(InvoiceItemModel item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        item.name,
        style: AppTextStyles.font16DarkGreyMedium,
      ),
      subtitle: Text(
        item.type,
        style: AppTextStyles.font16DarkGreyMedium.copyWith(
          color: AppColors.darkGrey.withOpacity(0.5),
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${item.quantity.toStringAsFixed(2)} Items',
            style: AppTextStyles.font16DarkGreyMedium,
          ),
          Text(
            '${(item.price * item.quantity).toStringAsFixed(2)} LE',
            style: AppTextStyles.font14DarkGreyMedium.copyWith(
              color: AppColors.darkGrey.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.white,
      border: Border.all(
        color: AppColors.darkGrey.withOpacity(0.25),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.15),
          blurRadius: 3,
          spreadRadius: 2,
          offset: const Offset(2, 2),
        ),
      ],
    );
  }
}
