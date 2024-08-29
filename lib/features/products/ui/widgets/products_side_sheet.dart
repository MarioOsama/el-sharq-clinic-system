import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_field.dart';
import 'package:el_sharq_clinic/core/widgets/custom_side_sheet.dart';
import 'package:el_sharq_clinic/core/widgets/section_title.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/products/logic/cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showProductSheet(BuildContext context, String title,
    {ProductModel? product, bool editable = true}) async {
  final ProductsCubit productsCubit = context.read<ProductsCubit>();
  final bool newProduct = product == null;
  // Setup sheet data depends on service is existing or new
  newProduct
      ? productsCubit.setupNewSheet()
      : productsCubit.setupExistingSheet(product);

  await showCustomSideSheet(
    context: context,
    scrollable: false,
    child: Form(
      key: productsCubit.productFormKey,
      child: Column(
        children: [
          SectionTitle(title: title),
          verticalSpace(50),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: AppTextField(
                  hint: 'Product Name',
                  initialValue: product?.title,
                  enabled: editable,
                  maxWidth: double.infinity,
                  validator: (p0) {
                    if (p0!.trim().isEmpty) {
                      productsCubit.onRequiredFieldEmpty('Product Name');
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      context.read<ProductsCubit>().onFieldSave('title', value),
                ),
              ),
              horizontalSpace(20),
              Expanded(
                child: AppTextField(
                  hint: 'Price',
                  initialValue: product?.price.toString(),
                  enabled: editable,
                  validator: (p0) {
                    if (p0!.trim().isEmpty ||
                        double.tryParse(p0) == null ||
                        p0 == '0') {
                      productsCubit.onRequiredFieldEmpty('Price');
                      return 'Service price is required, and must be a positive number greater than 0';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      context.read<ProductsCubit>().onFieldSave('price', value),
                ),
              ),
            ],
          ),
          verticalSpace(50),
          AppTextField(
            hint: 'Description',
            initialValue: product?.description,
            enabled: editable,
            isMultiline: true,
            maxWidth: double.infinity,
            onSaved: (value) =>
                context.read<ProductsCubit>().onFieldSave('description', value),
          ),
          const Spacer(),
          _buildActionIfNeeded(context, newProduct, editable),
        ],
      ),
    ),
  );
}

_buildActionIfNeeded(BuildContext context, bool newProduct, bool editMode) {
  if (newProduct) {
    return _buildNewAction(context);
  } else if (editMode) {
    return _buildUpdateAction(context);
  }
  return const SizedBox.shrink();
}

AppTextButton _buildNewAction(BuildContext context) {
  return AppTextButton(
    text: 'Save Product',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<ProductsCubit>().onSaveProduct();
    },
  );
}

AppTextButton _buildUpdateAction(BuildContext context) {
  return AppTextButton(
    text: 'Update Product',
    width: MediaQuery.sizeOf(context).width,
    height: 70.h,
    onPressed: () {
      context.read<ProductsCubit>().onUpdateProduct();
    },
  );
}
