import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/products/logic/cubit/products_cubit.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItemActionButton extends StatelessWidget {
  const ProductItemActionButton({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: 'Edit',
            onTap: () =>
                showProductSheet(context, 'Edit Product', product: product),
            child: const Text(
              'Edit',
              style: AppTextStyles.font14DarkGreyMedium,
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            onTap: () {
              showDialog(
                context: ctx,
                builder: (_) => AppAlertDialog(
                  alertMessage:
                      'Are you sure you want to delete this product?\n'
                      'This action cannot be undone.',
                  onConfirm: () {
                    context.read<ProductsCubit>().onDeleteProduct(product.id);
                    ctx.pop();
                  },
                  onCancel: () {
                    ctx.pop();
                  },
                ),
              );
            },
            child: const Text(
              'Delete',
              style: AppTextStyles.font14DarkGreyMedium,
            ),
          ),
        ];
      },
    );
  }
}
