part of 'products_cubit.dart';

abstract class ProductsState {
  final ProductType? selectedProductType;
  ProductsState({this.selectedProductType});
  takeAction(BuildContext context) {}
}

final class ProductsInitial extends ProductsState {
  ProductsInitial({super.selectedProductType});
}

final class ProductsLoading extends ProductsState {
  ProductsLoading({super.selectedProductType});
}

final class ProductsSuccess extends ProductsState {
  final List<ProductModel> products;

  ProductsSuccess({required this.products, required super.selectedProductType});
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
          return const Center(child: AnimatedLoadingIndicator());
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
        title: 'Error',
        content: message,
        dialogType: DialogType.error,
        action: AppTextButton(
          text: 'OK',
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
        title: 'Success',
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
