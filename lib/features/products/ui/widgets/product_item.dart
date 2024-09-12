import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/product_item_action_button.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showProductSheet(context, 'Product Details',
          editable: false, product: product),
      mouseCursor: SystemMouseCursors.click,
      child: Container(
        alignment: Alignment.center,
        decoration: _buildDecoration(),
        padding: const EdgeInsets.all(10),
        child: _buildListTile(context),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: AppColors.darkGrey.withOpacity(0.5),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.darkGrey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    );
  }

  ListTile _buildListTile(BuildContext context) {
    return ListTile(
      mouseCursor: SystemMouseCursors.click,
      horizontalTitleGap: 30.w,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            product.title,
            style: AppTextStyles.font16DarkGreyMedium(context),
          ),
        ),
      ),
      subtitle: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.scaleDown,
        child: Text(
          '${product.price} LE',
          style: AppTextStyles.font16DarkGreyMedium(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: ProductItemActionButton(
        product: product,
      ),
    );
  }
}
