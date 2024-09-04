import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/statistics_item_title.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';

class LowStockProducts extends StatelessWidget {
  const LowStockProducts({super.key, required this.items});

  final List<ProductModel> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatisticsItemTitle(title: 'Low Stock Products'),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Item',
          style: AppTextStyles.font16DarkGreyMedium,
        ),
        Text(
          'Quantity',
          style: AppTextStyles.font16DarkGreyMedium,
        ),
      ],
    );
  }

  ListTile _getItem(ProductModel item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        item.title,
        style: AppTextStyles.font16DarkGreyMedium,
      ),
      // subtitle: Text(
      //   item.,
      //   style: AppTextStyles.font16DarkGreyMedium.copyWith(
      //     color: AppColors.darkGrey.withOpacity(0.5),
      //   ),
      // ),
      trailing: Text(
        item.quantity.toString(),
        style: AppTextStyles.font16DarkGreyMedium,
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
