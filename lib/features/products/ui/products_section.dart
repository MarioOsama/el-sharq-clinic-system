import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_bloc_listener.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_body.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_side_sheet.dart';
import 'package:flutter/material.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'Products',
      actions: [
        // Search bar
        SectionSearchBar(
            hintText: 'Search by product name', onChanged: (value) {}),
        SectionActionButton(
          newText: 'New Product',
          onNewPressed: () => showProductSheet(context, 'New Product'),
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
