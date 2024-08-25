import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/app_grid_view.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/product_item.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsBody extends StatelessWidget {
  const ProductsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: EdgeInsets.only(bottom: 25.h),
      color: AppColors.white,
      child: Column(
        children: [
          _buildTabBar(context),
          Expanded(child: _buildGridView(context)),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return const ProductsSwitchButton();
  }

  AppGridView _buildGridView(BuildContext context) {
    return AppGridView(
      itemCount: 10,
      crossAxisCount: 4,
      childAspectRatio: 2,
      itemBuilder: (_, index) => ProductItem(),
    );
  }
}
