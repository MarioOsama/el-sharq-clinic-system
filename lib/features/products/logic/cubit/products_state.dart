part of 'products_cubit.dart';

abstract class ProductsState {
  final ProductType selectedProductType;
  ProductsState({required this.selectedProductType});
  takeAction(BuildContext context) {}
}

final class ProductsInitial extends ProductsState {
  ProductsInitial({required super.selectedProductType});
}

final class ProductsLoading extends ProductsState {
  ProductsLoading({required super.selectedProductType});
}

final class ProductsSuccess extends ProductsState {
  final List<ProductModel> products;

  ProductsSuccess({required this.products, required super.selectedProductType});

  @override
  void takeAction(BuildContext context) {
    if (products.isNotEmpty) {
      if (selectedProductType == ProductType.medicines) {
        context.read<MainCubit>().updateMedicinesList(products);
      } else {
        context.read<MainCubit>().updateAccessoriesList(products);
      }
    }
  }
}

final class ProductsSearchSuccess extends ProductsState {
  final List<ProductModel> products;
  ProductsSearchSuccess(
      {required this.products, required super.selectedProductType});
}

final class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message, required super.selectedProductType});
}

final class ProductInProgress extends ProductsState {
  ProductInProgress({required super.selectedProductType});
  @override
  void takeAction(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: FadedAnimatedLoadingIcon());
        });
  }
}

final class ProductInvalid extends ProductsState {
  final String message;
  ProductInvalid({required this.message, required super.selectedProductType});

  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: AppStrings.error.tr(),
        content: message,
        dialogType: DialogType.error,
        action: AppTextButton(
          text: AppStrings.ok.tr(),
          onPressed: () => context.pop(),
          filled: false,
        ),
      ),
    );
  }
}

final class ProductSuccessOperation extends ProductsState {
  final String message;
  final int popCount;
  ProductSuccessOperation(
      {required this.message,
      required super.selectedProductType,
      this.popCount = 1});

  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
    for (var i = 0; i < popCount; i++) {
      context.pop();
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AppDialog(
        title: AppStrings.success.tr(),
        content: message,
        dialogType: DialogType.success,
      ),
    );
    // Hide success dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }
}
