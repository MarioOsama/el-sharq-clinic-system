import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/products/data/repos/products_repo.dart';
import 'package:el_sharq_clinic/features/products/ui/widgets/products_switch_button.dart';
import 'package:flutter/material.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo _productsRepo;
  ProductsCubit(this._productsRepo) : super(ProductsInitial());

  // Variables
  AuthDataModel? _authData;
  GlobalKey<FormState> productFormKey = GlobalKey<FormState>();
  ProductType selectedProductType = ProductType.medicines;
  List<ProductModel> medicinesList = [];
  List<ProductModel> accessoriesList = [];
  List<ProductModel> searchResult = [];
  ProductModel productInfo = ProductModel(
    id: '',
    title: '',
    price: 0,
    description: '',
  );

  // Setup section data
  void setupSectionData(AuthDataModel authData) {
    _authData = authData;
    _getProducts();
  }

  void _getProducts() async {
    emit(ProductsLoading(
      selectedProductType: selectedProductType,
    ));
    if (ProductType.medicines == selectedProductType && medicinesList.isEmpty ||
        ProductType.accessories == selectedProductType &&
            accessoriesList.isEmpty) {
      try {
        final List<ProductModel> newProductsList =
            await _productsRepo.getProducts(
          clinicIndex: _authData!.clinicIndex,
          collection: selectedProductType.name,
        );
        selectedProductType == ProductType.medicines
            ? medicinesList.addAll(newProductsList)
            : accessoriesList.addAll(newProductsList);
      } catch (e) {
        emit(ProductsError(
            selectedProductType: selectedProductType,
            message: _getErrorMessage('get', selectedProductType.name)));
      }
    }
    emit(ProductsSuccess(
        selectedProductType: selectedProductType,
        products: selectedProductType == ProductType.medicines
            ? medicinesList
            : accessoriesList));
  }

  Future<void> addProduct() async {
    emit(ProductInProgress(selectedProductType: selectedProductType));

    final bool successAdding = await _productsRepo.addProduct(
        clinicIndex: _authData!.clinicIndex,
        collection: selectedProductType.name,
        product: productInfo);

    if (successAdding) {
      if (selectedProductType == ProductType.medicines) {
        medicinesList.add(productInfo);
      } else {
        accessoriesList.add(productInfo);
      }
    }
  }

  Future<void> updateProduct() async {
    emit(ProductInProgress(selectedProductType: selectedProductType));

    final bool successUpdating = await _productsRepo.updateProduct(
        clinicIndex: _authData!.clinicIndex,
        collection: selectedProductType.name,
        product: productInfo);

    if (successUpdating) {
      if (selectedProductType == ProductType.medicines) {
        final int index =
            medicinesList.indexWhere((product) => product.id == productInfo.id);

        medicinesList[index] = productInfo;
      } else {
        final int index = accessoriesList
            .indexWhere((product) => product.id == productInfo.id);
        accessoriesList[index] = productInfo;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    emit(ProductInProgress(selectedProductType: selectedProductType));

    final bool successDeleting = await _productsRepo.deleteProduct(
        clinicIndex: _authData!.clinicIndex,
        collection: selectedProductType.name,
        id: id);

    if (successDeleting) {
      if (selectedProductType == ProductType.medicines) {
        medicinesList.removeWhere((product) => product.id == id);
      } else {
        accessoriesList.removeWhere((product) => product.id == id);
      }
    }
  }

  bool _checkProductExistance() {
    if (selectedProductType == ProductType.medicines) {
      if (medicinesList.any((product) =>
          product.title.toLowerCase() == productInfo.title.toLowerCase())) {
        return true;
      }
    } else {
      if (accessoriesList.any((product) =>
          product.title.toLowerCase() == productInfo.title.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  String _getErrorMessage(String action, String type) {
    return 'Failed to $action the $type';
  }

  void _onSuccessOperation(String operationMessage, {int popCount = 2}) {
    emit(ProductsLoading(selectedProductType: selectedProductType));
    emit(ProductSuccessOperation(
        message: operationMessage,
        selectedProductType: selectedProductType,
        popCount: popCount));
    Future.delayed(const Duration(seconds: 1), () {
      emit(ProductsSuccess(
          selectedProductType: selectedProductType,
          products: selectedProductType == ProductType.medicines
              ? medicinesList
              : accessoriesList));
    });
  }

  // UI methods
  void setupNewSheet() {
    productFormKey = GlobalKey<FormState>();
    productInfo = ProductModel(
      id: '',
      title: '',
      price: 0,
      description: '',
    );
  }

  void setupExistingSheet(ProductModel product) {
    productInfo = product;
  }

  void toggleProductType(ProductType type) {
    selectedProductType = type;
    emit(ProductsInitial(selectedProductType: selectedProductType));
    _getProducts();
  }

  void onRequiredFieldEmpty(String fieldName) {
    emit(
      ProductInvalid(
          message: 'Please enter a valid $fieldName',
          selectedProductType: selectedProductType),
    );
  }

  void onFieldSave(String field, String? value) {
    productInfo = productInfo.copyWith(
      id: productInfo.id == ''
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : productInfo.id,
      title: field == 'title' ? value : productInfo.title,
      price: field == 'price' ? double.parse(value!) : productInfo.price,
      description: field == 'description' ? value : productInfo.description,
    );
  }

  void onSaveProduct() async {
    if (productFormKey.currentState!.validate()) {
      productFormKey.currentState!.save();
      final bool isExistingProduct = _checkProductExistance();
      if (isExistingProduct) {
        emit(ProductInvalid(
            message: 'Product already exist',
            selectedProductType: selectedProductType));
        return;
      }
      await addProduct();
      _onSuccessOperation('Product saved successfully');
    }
  }

  void onUpdateProduct() async {
    if (productFormKey.currentState!.validate()) {
      productFormKey.currentState!.save();
      final bool isExistingProduct = _checkProductExistance();
      if (isExistingProduct) {
        emit(ProductInvalid(
            message: 'Product already exist',
            selectedProductType: selectedProductType));
        return;
      }
      await updateProduct();
      _onSuccessOperation('Product updated successfully');
    }
  }

  void onDeleteProduct(String id) async {
    await deleteProduct(id);
    _onSuccessOperation('Product deleted successfully', popCount: 1);
  }

  void onSearch(String value) {
    if (value.isEmpty) {
      searchResult = [];
      emit(ProductsSuccess(
          selectedProductType: selectedProductType,
          products: selectedProductType == ProductType.medicines
              ? medicinesList
              : accessoriesList));

      return;
    } else {
      searchResult = selectedProductType == ProductType.medicines
          ? medicinesList
              .where((product) =>
                  product.title.toLowerCase().contains(value.toLowerCase()))
              .toList()
          : accessoriesList
              .where((product) =>
                  product.title.toLowerCase().contains(value.toLowerCase()))
              .toList();
    }
    emit(ProductsSuccess(
        selectedProductType: selectedProductType, products: searchResult));
  }
}
