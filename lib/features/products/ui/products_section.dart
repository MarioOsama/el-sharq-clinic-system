import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/products/logic/cubit/products_cubit.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_bloc_listener.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_body.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: AppStrings.products.tr(),
      actions: [
        // Search bar
        SectionSearchBar(
            hintText: AppStrings.productsSearchText.tr(),
            onChanged: (value) =>
                context.read<ProductsCubit>().onSearch(value)),
        SectionActionButton(
          newText: AppStrings.newProduct.tr(),
          onNewPressed: () =>
              showProductSheet(context, AppStrings.newProduct.tr()),
        ),
      ],
      child: Expanded(
        child: Column(
          children: [
            verticalSpace(50),
            const Expanded(child: ProductsBody()),
            const ProductsBlocListener(),
          ],
        ),
      ),
    );
  }
}
