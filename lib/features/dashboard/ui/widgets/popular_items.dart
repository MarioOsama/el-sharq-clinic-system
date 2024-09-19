import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/dashboard_stats_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/statistics_item_title.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';
import 'package:flutter/material.dart';

class PopularItems extends StatelessWidget {
  const PopularItems({super.key, required this.items, this.aspectRatio});

  final List<InvoiceItemModel> items;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    return DashboardStatsContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatisticsItemTitle(title: AppStrings.popularItemsLastWeek.tr()),
          verticalSpace(20),
          _buildHeaderRow(context),
          Divider(
            color: AppColors.darkGrey.withOpacity(0.25),
          ),
          AspectRatio(
            aspectRatio: aspectRatio ?? 2.85,
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
      children: [
        Text(
          AppStrings.item.tr(),
          style: AppTextStyles.font16DarkGreyMedium(context),
        ),
        const Spacer(),
        Text(
          AppStrings.sales.tr(),
          style: AppTextStyles.font16DarkGreyMedium(context),
        ),
      ],
    );
  }

  Widget _getItem(InvoiceItemModel item, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      isThreeLine: true,
      title: Text(
        item.name,
        style: AppTextStyles.font16DarkGreyMedium(context),
      ),
      subtitle: Text(
        item.type.tr(),
        style: AppTextStyles.font16DarkGreyMedium(context).copyWith(
          color: AppColors.darkGrey.withOpacity(0.5),
        ),
      ),
      trailing: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.quantity.toStringAsFixed(2)} ${AppStrings.items.tr()}',
              style: AppTextStyles.font16DarkGreyMedium(context),
            ),
            Text(
              '${(item.price * item.quantity).toStringAsFixed(2)} ${AppStrings.le.tr()}',
              style: AppTextStyles.font14DarkGreyMedium(context).copyWith(
                color: AppColors.darkGrey.withOpacity(0.5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
