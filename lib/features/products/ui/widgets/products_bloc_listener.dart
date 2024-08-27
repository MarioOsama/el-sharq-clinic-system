import 'package:el_sharq_clinic/features/products/logic/cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsBlocListener extends StatelessWidget {
  const ProductsBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listenWhen: (previous, current) =>
          current is ProductInProgress ||
          current is ProductInvalid ||
          current is ProductSuccessOperation,
      listener: (context, state) {
        state.takeAction(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
