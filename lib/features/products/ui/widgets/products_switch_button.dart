import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsSwitchButton extends StatelessWidget {
  const ProductsSwitchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      expandedInsets: EdgeInsets.zero,
      selected: const {ProductType.accessories},
      onSelectionChanged: (value) {},
      style: _buildStyle,
      segments: _getSegments,
      selectedIcon: const SizedBox.shrink(),
    );
  }

  List<ButtonSegment<ProductType>> get _getSegments {
    return [
      ButtonSegment(
        value: ProductType.accessories,
        label: Text('Accessories',
            style: AppTextStyles.font24DarkGreyMedium
                .copyWith(color: AppColors.white)),
      ),
      ButtonSegment(
        value: ProductType.medicines,
        label: Text('Medicines',
            style: AppTextStyles.font24DarkGreyMedium
                .copyWith(color: AppColors.darkGrey)),
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
