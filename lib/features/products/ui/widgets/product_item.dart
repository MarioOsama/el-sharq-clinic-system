import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/product_item_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
  });

  // TODO:Receive data model

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        decoration: _buildDecoration(),
        padding: const EdgeInsets.all(10),
        child: _buildListTile(),
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

  ListTile _buildListTile() {
    return ListTile(
      horizontalTitleGap: 30.w,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          'Product Name',
          style: AppTextStyles.font16DarkGreyMedium,
        ),
      ),
      subtitle: Text(
        '150 LE',
        style: AppTextStyles.font16DarkGreyMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: ProductItemActionButton(),
    );
  }
}
