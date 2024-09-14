import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/app_grid_view.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/products/logic/cubit/products_cubit.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/product_item.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
            buildWhen: (previous, current) =>
                current is ProductsSuccess ||
                current is ProductsSearchSuccess ||
                current is ProductsError ||
                current is ProductsLoading,
            builder: _buildChild,
          )),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return const ProductsSwitchButton();
  }

  Widget _buildChild(BuildContext context, ProductsState state) {
    if (state is ProductsError) {
      return Center(
          child: Text(state.message,
              style: AppTextStyles.font20DarkGreyMedium(context)));
    } else if (state is ProductsSuccess) {
      return _buildSuccess(context, state.products, state.selectedProductType);
    } else if (state is ProductsSearchSuccess) {
      return _buildSuccess(context, state.products, state.selectedProductType);
    } else {
      return const FadedAnimatedLoadingIcon();
    }
  }

  Widget _buildSuccess(
      BuildContext context, List<ProductModel> products, ProductType type) {
    if (products.isEmpty) {
      return _buildEmptyView(type, context);
    }
    return _buildGridView(products);
  }

  AppGridView _buildGridView(List<ProductModel> products) {
    return AppGridView(
      itemCount: products.length,
      crossAxisCount: 4,
      childAspectRatio: 2,
      itemBuilder: (_, index) => ProductItem(
        product: products[index],
      ),
    );
  }

  Widget _buildEmptyView(ProductType productType, BuildContext context) {
    return Center(
      child: Text(
        AppStrings.noProducts.tr(),
        style: AppTextStyles.font20DarkGreyMedium(context),
      ),
    );
  }
}
