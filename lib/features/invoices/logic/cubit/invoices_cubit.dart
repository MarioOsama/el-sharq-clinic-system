import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
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
  TextEditingController totalController = TextEditingController();

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
  );

  // Get Invoices Functions
  void setupSectionData(
      AuthDataModel authenticationData, BuildContext context) {
    _setAuthData(authenticationData);
    _setupSelableItemsListsData(context);
    _getPaginatedInvoices();
  }

  void _setupSelableItemsListsData(BuildContext context) async {
    final MainCubit mainCubit = context.read<MainCubit>();
    servicesList = mainCubit.servicesList;
    medicinesList = mainCubit.medicinesList;
    accessoriesList = mainCubit.accessorieList;
    if (servicesList.isEmpty ||
        medicinesList.isEmpty ||
        accessoriesList.isEmpty) {
      await loadSelableItemsLists();
      updateSelableItemsListsInMainCubit(mainCubit);
    }
  }

  Future<void> loadSelableItemsLists() async {
    final result =
        await _invoicesRepo.loadSelableItemsLists(authData!.clinicIndex);
    servicesList = result[0] as List<ServiceModel>;
    medicinesList = result[1] as List<ProductModel>;
    accessoriesList = result[2] as List<ProductModel>;
  }

  void updateSelableItemsListsInMainCubit(MainCubit cubit) {
    cubit.updateServicesList(
      servicesList,
    );
    cubit.updateMedicinesList(
      medicinesList,
    );
    cubit.updateAccessoriesList(
      accessoriesList,
    );
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
    emit(InvoiceInProgress());
    // Save items forms
    _setInvoiceIdentifiers();
    final bool isAdded = await _invoicesRepo.addNewInvoice(
      authData!.clinicIndex,
      invoiceInfo,
    );
    if (isAdded) {
      invoicesList.insert(0, invoiceInfo);
      _onSuccessOperation('Invoice added successfully');
    } else {
      emit(InvoicesError(message: 'Failed to add the invoice'));
    }
  }

  void _setInvoiceIdentifiers() {
    invoiceInfo = invoiceInfo.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now().toString(),
    );
  }

  bool _validateInvoiceItems() {
    for (int i = 0; i < itemFormsKeys.length; i++) {
      if (itemFormsKeys[i].currentState!.validate() &&
          invoiceInfo.items[i].name.trim() != '') {
        itemFormsKeys[i].currentState!.save();
      } else {
        emit(InvoiceConstrutingError(
          message: 'Item ${i + 1} is not valid, please check it',
        ));
        return false;
      }
    }
    if (invoiceInfo.discount > invoiceInfo.total) {
      emit(InvoiceConstrutingError(
        message: 'Discount can\'t be greater than total',
      ));
      return false;
    }
    emit(InvoiceConstruting(
        invoiceModel: invoiceInfo.copyWith(
      items: itemsList,
    )));
    return true;
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
      emit(InvoicesError(message: 'Failed to get the owner'));
      rethrow;
    }
  }

  void _onSuccessOperation(String message, {int popCount = 2}) async {
    emit(InvoicesLoading());
    emit(InvoiceSuccessOperation(message: message, popCount: popCount));
    await Future.delayed(const Duration(seconds: 1), () {
      selectedRows = List.filled(invoicesList.length, false);
      emit(InvoicesSuccess(invoices: invoicesList));
    });
  }

  // Delete Invoice Functions
  void deleteInvoice(String id) async {
    emit(InvoiceInProgress());
    final bool isDeleted = await _invoicesRepo.deleteInvoice(
      authData!.clinicIndex,
      id,
    );
    if (isDeleted) {
      invoicesList.removeWhere((invoice) => invoice!.id == id);
      showDeleteButtonNotifier.value = false;
      _onSuccessOperation('Invoice deleted successfully');
    } else {
      emit(InvoicesError(message: 'Failed to delete the invoice'));
    }
  }

  void deleteSelectedInvoices() async {
    emit(InvoicesLoading());
    try {
      final List<String> deletedInvoicesId = [];
      // Get all the selected doctors
      for (int i = 0; i < selectedRows.length; i++) {
        if (selectedRows.elementAt(i)) {
          deletedInvoicesId.add(invoicesList.elementAt(i)!.id);
        }
      }
      // Delete all the selected doctors
      for (String doctorId in deletedInvoicesId) {
        await _invoicesRepo.deleteInvoice(authData!.clinicIndex, doctorId);
        invoicesList.removeWhere((element) => element!.id == doctorId);
      }
      showDeleteButtonNotifier.value = false;
      _onSuccessOperation('Invoices deleted successfully', popCount: 1);
    } catch (e) {
      emit(InvoicesError(message: 'Failed to delete these selected cases'));
    }
  }

  // UI Functions
  void setupNewSheet() {
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
    );
    emit(InvoiceConstruting(invoiceModel: invoiceInfo));
  }

  void setupExistingSheet(InvoiceModel invoice) {
    itemFormsKeys =
        List.generate(invoice.items.length, (_) => GlobalKey<FormState>());
    invoiceInfo = invoice;
    emit(InvoiceConstruting(invoiceModel: invoiceInfo));
  }

  void incrementItems() {
    itemFormsKeys.add(GlobalKey<FormState>());
    itemsList.add(
      InvoiceItemModel(
        name: '',
        type: '',
        quantity: 1,
        price: 0,
      ),
    );
    emit(InvoiceConstruting(
        invoiceModel: invoiceInfo.copyWith(
      items: itemsList,
    )));
  }

  void decrementItems(int index) {
    itemFormsKeys.removeAt(index);
    itemsList.removeAt(index);
    emit(InvoiceConstruting(
        invoiceModel: invoiceInfo.copyWith(
      items: itemsList,
    )));
    updateTotal();
  }

  void onSaveInvoiceItemFormField(String field, String? value, int index) {
    itemsList[index] = itemsList[index].copyWith(
      name: field == 'name' ? value! : itemsList[index].name,
      type: field == 'type' ? value! : itemsList[index].type,
      quantity: field == 'quantity'
          ? double.parse(value!)
          : itemsList[index].quantity,
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
      if (itemType == 'Services') {
        item = servicesList.firstWhere((service) => service.title == value);
      } else if (itemType == 'Medicines') {
        item = medicinesList.firstWhere((service) => service.title == value);
      } else {
        item = accessoriesList.firstWhere((service) => service.title == value);
      }
      itemsList[itemIndex] = itemsList[itemIndex].copyWith(
        name: item.title,
        type: itemType,
        quantity: 1,
        price: item.price,
      );
    } else {
      itemsList[itemIndex] = itemsList[itemIndex].copyWith(
        name: '',
        type: '',
        quantity: 1,
        price: 0,
      );
    }
    updateTotal();
  }

  void onResetInvoiceItem(int index) {
    itemsList[index] = itemsList[index].copyWith(
      name: '',
      type: '',
      quantity: 1,
      price: 0,
    );
    updateTotal();
  }

  void updateItemQuantity(int index, double quantity) {
    itemsList[index] = itemsList[index].copyWith(quantity: quantity);
    emit(InvoiceConstruting(
        invoiceModel: invoiceInfo.copyWith(items: itemsList)));
    updateTotal();
  }

  void updateDiscount(double discount) {
    invoiceInfo = invoiceInfo.copyWith(discount: discount);
    emit(InvoiceConstruting(invoiceModel: invoiceInfo));
  }

  void updateTotal() {
    invoiceInfo = invoiceInfo.copyWith(
      total: itemsList
          .map((item) => item.price * item.quantity)
          .fold(0, (previousValue, element) => previousValue! + element),
    );
    emit(InvoiceConstruting(invoiceModel: invoiceInfo));
  }

  void onSaveNewInvoice() {
    if (_validateInvoiceItems()) {
      addNewInvoice();
    }
  }

  void onDeleteInvoice(
    String invoiceId,
    String clinicPassword,
  ) {
    if (authData!.userModel.password == clinicPassword) {
      deleteInvoice(invoiceId);
    } else {
      emit(InvoiceConstrutingError(message: 'Password is incorrect'));
    }
  }

  void onDeleteSelectedInvoices(String clinicPassword) {
    if (authData!.userModel.password == clinicPassword) {
      deleteSelectedInvoices();
    } else {
      emit(InvoiceConstrutingError(message: 'Password is incorrect'));
    }
  }
}
