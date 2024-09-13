import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/dashboard_stats_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/statistics_item_title.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';

class LowStockProducts extends StatelessWidget {
  const LowStockProducts({super.key, required this.items});

  final List<ProductModel> items;

  @override
  Widget build(BuildContext context) {
    return DashboardStatsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatisticsItemTitle(title: AppStrings.lowStockProducts.tr()),
          verticalSpace(20),
          _buildHeaderRow(context),
          Divider(
            color: AppColors.darkGrey.withOpacity(0.25),
          ),
          AspectRatio(
            aspectRatio: 2.85,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _getItem(item, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Row _buildHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.item.tr(),
          style: AppTextStyles.font16DarkGreyMedium(context),
        ),
        Text(
          AppStrings.quantity.tr(),
          style: AppTextStyles.font16DarkGreyMedium(context),
        ),
      ],
    );
  }

  ListTile _getItem(ProductModel item, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        item.title,
        style: AppTextStyles.font16DarkGreyMedium(context),
      ),
      subtitle: Text(
        item.type.toString().replaceAll('ProductType.', '').capitalize().tr(),
        style: AppTextStyles.font16DarkGreyMedium(context).copyWith(
          color: AppColors.darkGrey.withOpacity(0.5),
        ),
      ),
      trailing: Text(
        item.quantity.toString(),
        style: AppTextStyles.font16DarkGreyMedium(context),
      ),
    );
  }
}
