import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
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

  // Setup section data
  void setupSectionData(AuthDataModel authData) {
    log(selectedProductType.name);
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

  String _getErrorMessage(String action, String type) {
    return 'Failed to $action the $type';
  }

  // UI methods
  void toggleProductType(ProductType type) {
    selectedProductType = type;
    emit(ProductsInitial(selectedProductType: selectedProductType));
    _getProducts();
  }
}
