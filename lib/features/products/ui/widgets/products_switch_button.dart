import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/products/logic/cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsSwitchButton extends StatelessWidget {
  const ProductsSwitchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProductsCubit, ProductsState, ProductType?>(
      selector: (state) {
        return state.selectedProductType;
      },
      builder: (context, productType) {
        return SegmentedButton<ProductType?>(
          expandedInsets: EdgeInsets.zero,
          selected: {productType},
          onSelectionChanged: (value) {
            context
                .read<ProductsCubit>()
                .onToggleProductType(value.first!, context);
          },
          style: _buildStyle,
          segments: _getSegments(productType),
          selectedIcon: const SizedBox.shrink(),
        );
      },
    );
  }

  List<ButtonSegment<ProductType>> _getSegments(ProductType? productType) {
    return [
      ButtonSegment(
        value: ProductType.medicines,
        label: Text('Medicines',
            style: AppTextStyles.font24DarkGreyMedium.copyWith(
                color: productType == ProductType.medicines
                    ? AppColors.white
                    : AppColors.darkGrey)),
      ),
      ButtonSegment(
        value: ProductType.accessories,
        label: Text('Accessories',
            style: AppTextStyles.font24DarkGreyMedium.copyWith(
                color: productType == ProductType.accessories
                    ? AppColors.white
                    : AppColors.darkGrey)),
      ),
    ];
  }

  ButtonStyle get _buildStyle {
    return SegmentedButton.styleFrom(
      backgroundColor: AppColors.white,
      selectedBackgroundColor: AppColors.blue.withOpacity(0.85),
      selectedForegroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.white, width: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
    );
  }
}

enum ProductType { accessories, medicines }
