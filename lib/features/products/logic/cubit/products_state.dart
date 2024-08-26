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

final class ProductSaving extends ProductsState {
  ProductSaving({required super.selectedProductType});
}

final class ProductInvalid extends ProductsState {
  final String fieldName;
  ProductInvalid({required this.fieldName, required super.selectedProductType});
}

final class ProductSuccessOperation extends ProductsState {
  final String message;
  ProductSuccessOperation(
      {required this.message, required super.selectedProductType});
}

final class ProductErrorOperation extends ProductsState {
  ProductErrorOperation({required super.selectedProductType});
}
