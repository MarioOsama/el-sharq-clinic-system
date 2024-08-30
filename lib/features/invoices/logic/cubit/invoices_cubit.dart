import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/repos/invoices_repo.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  final InvoicesRepo _invoicesRepo;
  InvoicesCubit(this._invoicesRepo) : super(InvoicesInitial());

  // Variables
  AuthDataModel? authData;
  ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);
  ValueNotifier<int> numberOfItemsNotifier = ValueNotifier(0);
  List<GlobalKey<FormState>> itemFormsKeys = [];

  List<InvoiceModel?> invoicesList = [];
  List<InvoiceModel?> searchResult = [];
  List<bool> selectedRows = [];
  List<InvoiceItemModel> itemsList = [];
  List<ServiceModel> servicesList = [];
  List<ProductModel> medicinesList = [];
  List<ProductModel> accessoriesList = [];

  int pageLength = 10;

  InvoiceModel invoiceInfo = InvoiceModel(
    id: '',
    date: DateTime.now().toString(),
    items: [],
    total: 0,
    discount: 0,
    numberOfItems: 0,
  );

  // Get Invoices Functions
  void setupSectionData(
      AuthDataModel authenticationData, BuildContext context) {
    _setupSelableItemsListsData(context);
    _setAuthData(authenticationData);
    _getPaginatedInvoices();
  }

  void _setupSelableItemsListsData(BuildContext context) {
    servicesList = context.read<MainCubit>().servicesList;

    medicinesList = context.read<MainCubit>().medicinesList;

    accessoriesList = context.read<MainCubit>().accessorieList;
  }

  void _setAuthData(AuthDataModel authenticationData) {
    authData = authenticationData;
  }

  void _getPaginatedInvoices() async {
    emit(InvoicesLoading());
    try {
      final List<InvoiceModel> newInvoicesList =
          await _invoicesRepo.getInvoices(
        authData!.clinicIndex,
        null,
      );

      invoicesList.addAll(newInvoicesList);
      selectedRows = List.filled(invoicesList.length, false);
      emit(InvoicesSuccess(invoices: invoicesList));
    } catch (e) {
      emit(InvoicesError(message: 'Failed to get the invoices'));
    }
  }

  void getNextPage(int firstIndex) async {
    String? lastInvoiceId = invoicesList.lastOrNull?.id;
    final String? lastInvoiceIdInFirestore = await getFirstInvoiceId();
    final bool isLastPage = invoicesList.length - firstIndex <= pageLength;
    if (lastInvoiceIdInFirestore.toString() != lastInvoiceId.toString() &&
        isLastPage) {
      try {
        final List<InvoiceModel> newInvoicesList = await _invoicesRepo
            .getInvoices(authData!.clinicIndex, lastInvoiceId);
        invoicesList.addAll(newInvoicesList);
        selectedRows = List.filled(invoicesList.length, false);
        emit(InvoicesSuccess(invoices: invoicesList));
      } catch (e) {
        emit(InvoicesError(message: 'Failed to get the Invoices'));
      }
    }
  }

  // Add New Invoice Functions
  void addNewInvoice() async {
    emit(InvoicesLoading());
    // Save items forms
    _validateAndSaveItemsForms();

    try {
      final bool isAdded = await _invoicesRepo.addNewInvoice(
        authData!.clinicIndex,
        invoiceInfo,
      );
      if (isAdded) {
        emit(InvoicesSuccess(invoices: invoicesList));
      } else {
        emit(InvoicesError(message: 'Failed to add the invoice'));
      }
    } catch (e) {
      emit(InvoicesError(message: 'Failed to add the invoice'));
    }
  }

  _validateAndSaveItemsForms() {
    for (int i = 0; i < itemFormsKeys.length; i++) {
      if (itemFormsKeys[i].currentState!.validate()) {
        itemFormsKeys[i].currentState!.save();
        invoiceInfo.items.add(itemsList[i]);
      }
    }
  }

  Future<String?> getFirstInvoiceId() async {
    return await _invoicesRepo.getLastInvoiceId(authData!.clinicIndex, false);
  }

  InvoiceModel getInvoiceById(String invoiceId) {
    try {
      if (searchResult.isEmpty) {
        return invoicesList.firstWhere((invoice) => invoice!.id == invoiceId)
            as InvoiceModel;
      } else {
        return searchResult.firstWhere((invoice) => invoice!.id == invoiceId)
            as InvoiceModel;
      }
    } catch (e) {
      log(e.toString());
      emit(InvoicesError(message: 'Failed to get the owner'));
      rethrow;
    }
  }

  // UI Functions
  void setupNewSheet() {
    numberOfItemsNotifier.value = 1;
    itemFormsKeys = [GlobalKey<FormState>()];
    itemsList = [
      InvoiceItemModel(
        name: '',
        type: '',
        quantity: 1,
        price: 0,
      ),
    ];
    invoiceInfo = InvoiceModel(
      id: '',
      date: DateTime.now().toString(),
      items: itemsList,
      total: 0,
      discount: 0,
      numberOfItems: numberOfItemsNotifier.value,
    );
  }

  void setupExistingSheet(InvoiceModel invoice) {
    itemFormsKeys =
        List.generate(invoice.numberOfItems, (_) => GlobalKey<FormState>());
    numberOfItemsNotifier.value = invoice.numberOfItems;
    invoiceInfo = invoice;
  }

  void incrementItems() {
    numberOfItemsNotifier.value++;
    itemFormsKeys.add(GlobalKey<FormState>());
    itemsList.add(
      InvoiceItemModel(
        name: '',
        type: '',
        quantity: 1,
        price: 0,
      ),
    );
    emit(InvoiceItemsChanged(numberOfItems: numberOfItemsNotifier.value));
  }

  void decrementItems(int index) {
    numberOfItemsNotifier.value--;
    itemFormsKeys.removeAt(index);
    final deletedItem = itemsList.removeAt(index);
    invoiceInfo.items.remove(deletedItem);
    emit(InvoiceItemsChanged(numberOfItems: numberOfItemsNotifier.value));
  }

  void onSaveInvoiceItemFormField(String field, String? value, int index) {
    log('field: $field, value: $value, index: $index');
    itemsList[index] = itemsList[index].copyWith(
      name: field == 'name' ? value! : itemsList[index].name,
      type: field == 'type' ? value! : itemsList[index].type,
      quantity:
          field == 'quantity' ? int.parse(value!) : itemsList[index].quantity,
      price: field == 'price' ? double.parse(value!) : itemsList[index].price,
    );
  }

  void onMultiSelection(int index, bool selected) {
    if (selectedRows.elementAt(index)) {
      selectedRows[index] = false;
    } else {
      selectedRows[index] = true;
    }

    if (selectedRows.any((element) => element)) {
      showDeleteButtonNotifier.value = true;
    } else {
      showDeleteButtonNotifier.value = false;
    }
  }

  List<DropdownMenuEntry<String>> onItemSearch(
      List<DropdownMenuEntry<String>> entries,
      List<String> allItems,
      String filter) {
    if (allItems.isNotEmpty && entries.isNotEmpty) {
      final List<DropdownMenuEntry<String>> allItemsEntries = allItems
          .map((item) => DropdownMenuEntry(
                value: item,
                label: item,
              ))
          .toList();

      if (filter.isEmpty) {
        return allItemsEntries.length > 20
            ? allItemsEntries.sublist(0, 20)
            : allItemsEntries;
      }

      List<String> filteredEntries = entries
          .map((entry) => entry.value)
          .where((value) => value.toLowerCase().contains(filter.toLowerCase()))
          .toList();

      if (filteredEntries.isEmpty) {
        filteredEntries = allItems
            .where((item) => item.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      }

      final List<DropdownMenuEntry<String>> filteredItems =
          filteredEntries.map((entry) {
        return DropdownMenuEntry(
          value: entry,
          label: entry,
        );
      }).toList();

      return filteredItems.length > 20
          ? filteredItems.sublist(0, 20)
          : filteredItems.isEmpty
              ? [
                  const DropdownMenuEntry(
                    value: 'No items found',
                    label: 'No items found',
                  ),
                ]
              : filteredItems;
    }

    return entries;
  }

  void onItemSelected(String? value, String itemType, int itemIndex) {
    if (value != null && value.trim().isNotEmpty && value != 'No items found') {
      SelableItemModel item;
      if (itemType == 'Service') {
        item = servicesList.firstWhere((service) => service.title == value);
      } else if (itemType == 'Medicines') {
        item = medicinesList.firstWhere((service) => service.title == value);
      } else {
        item = accessoriesList.firstWhere((service) => service.title == value);
      }
      itemsList[itemIndex - 1] = itemsList[itemIndex - 1].copyWith(
        name: item.title,
        type: itemType,
        quantity: 1,
        price: item.price,
      );
      log('Items List: $itemsList');
    }
  }
}
