import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/products/data/repos/products_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo _productsRepo;
  ProductsCubit(this._productsRepo)
      : super(ProductsInitial(selectedProductType: ProductType.medicines));

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
    quantity: 0,
    type: ProductType.medicines,
    description: '',
  );

  // Setup section data
  void setupSectionData(AuthDataModel authData, BuildContext context) async {
    _authData = authData;
    _getProducts(context);
  }

  void _getProducts(BuildContext context) async {
    emit(ProductsLoading(
      selectedProductType: selectedProductType,
    ));

    getLoadedProductsIfExist(context);

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

  void getLoadedProductsIfExist(BuildContext context) {
    if (medicinesList.isEmpty) {
      medicinesList = context.read<MainCubit>().medicinesList;
    } else if (accessoriesList.isEmpty) {
      accessoriesList = context.read<MainCubit>().accessorieList;
    }
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
      if (medicinesList
          .where((medicine) =>
              medicine.title == productInfo.title &&
              medicine.id != productInfo.id)
          .isNotEmpty) {
        return true;
      }
    } else {
      if (accessoriesList
          .where(
            (accessory) =>
                accessory.title == productInfo.title &&
                accessory.id != productInfo.id,
          )
          .isNotEmpty) {
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
      quantity: 0,
      type: selectedProductType,
      description: '',
    );
  }

  void setupExistingSheet(ProductModel product) {
    productInfo = product;
  }

  void onToggleProductType(ProductType type, BuildContext context) {
    selectedProductType = type;
    _getProducts(context);
  }

  void onRequiredFieldEmpty(String fieldName) {
    emit(
      ProductInvalid(
          message: '${AppStrings.pleaseEnter.tr()} $fieldName',
          selectedProductType: selectedProductType),
    );
  }

  void onFieldSave(String field, String? value) {
    productInfo = productInfo.copyWith(
      id: productInfo.id == ''
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : productInfo.id,
      title: field == 'Title' ? value : productInfo.title,
      price: field == 'Price' ? double.parse(value!) : productInfo.price,
      quantity:
          field == 'Quantity' ? double.parse(value!) : productInfo.quantity,
      description: field == 'Description' ? value : productInfo.description,
    );
  }

  void onSaveProduct() async {
    if (productFormKey.currentState!.validate()) {
      productFormKey.currentState!.save();
      final bool isExistingProduct = _checkProductExistance();
      if (isExistingProduct) {
        emit(ProductInvalid(
            message: AppStrings.productAlreadyExist.tr(),
            selectedProductType: selectedProductType));
        return;
      }
      await addProduct();
      _onSuccessOperation(AppStrings.productSaved.tr());
    }
  }

  void onUpdateProduct() async {
    if (productFormKey.currentState!.validate()) {
      productFormKey.currentState!.save();
      final bool isExistingProduct = _checkProductExistance();
      if (isExistingProduct) {
        emit(ProductInvalid(
            message: AppStrings.productAlreadyExist.tr(),
            selectedProductType: selectedProductType));
        return;
      }
      await updateProduct();
      _onSuccessOperation(AppStrings.productUpdated.tr());
    }
  }

  void onDeleteProduct(String id) async {
    await deleteProduct(id);
    _onSuccessOperation(AppStrings.productDeleted.tr(), popCount: 1);
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
    emit(ProductsSearchSuccess(
        selectedProductType: selectedProductType, products: searchResult));
  }
}
