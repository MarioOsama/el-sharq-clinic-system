import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/repos/invoices_repo.dart';
import 'package:el_sharq_clinic/features/invoices/ui/widgets/pdf_invoice.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';

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
  UserModel adminUser = UserModel.empty();

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
    _getAdminUser();
    _getPaginatedInvoices();
  }

  void _setupSelableItemsListsData(BuildContext context) {
    final MainCubit mainCubit = context.read<MainCubit>();
    servicesList = mainCubit.servicesList;
    medicinesList = mainCubit.medicinesList;
    accessoriesList = mainCubit.accessorieList;
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

  void _getAdminUser() async {
    adminUser = await _invoicesRepo.getAdminUser(authData!.clinicIndex);
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
      emit(InvoicesError(message: AppStrings.failedToGetInvoices.tr()));
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
        emit(InvoicesError(message: AppStrings.failedToGetInvoices.tr()));
      }
    }
  }

  // Add New Invoice Functions
  void addNewInvoice(BuildContext context) async {
    // Save items forms
    _setInvoiceIdentifiers();
    _setInvoiceItemsDiscount();
    final int isUnavailableItems = _checkItemsAvailability(context);
    if (isUnavailableItems == -1) {
      emit(InvoiceInProgress());
      final bool isAdded = await _invoicesRepo.addNewInvoice(
        authData!.clinicIndex,
        invoiceInfo,
      );
      if (isAdded) {
        _decrementInvoiceItemsQuantity(context);
        invoicesList.insert(0, invoiceInfo);
        _onSuccessOperation(AppStrings.invoiceAddedSuccessfully.tr());
      } else {
        emit(InvoicesError(message: AppStrings.failedToAddInvoice.tr()));
      }
    } else {
      emit(InvoiceConstrutingError(
          message:
              '${AppStrings.pleaseCheckItem.tr()} ${isUnavailableItems + 1}\n${AppStrings.notEnoughItems.tr()}'));
    }
  }

  /// This function checks if there are enough items in stock for the current
  /// invoice.
  ///
  /// Returns the index of the first item in the invoice that there is not enough
  /// of in stock, or -1 if there is enough of all items.
  int _checkItemsAvailability(BuildContext context) {
    for (InvoiceItemModel item in invoiceInfo.items) {
      if (item.type == 'Medicines') {
        if (item.quantity >
            medicinesList
                .firstWhere((product) => product.title == item.name)
                .quantity) {
          return invoiceInfo.items.indexOf(item);
        }
      } else if (item.type == 'Accessories') {
        if (item.quantity >
            accessoriesList
                .firstWhere((product) => product.title == item.name)
                .quantity) {
          return invoiceInfo.items.indexOf(item);
        }
      }
    }
    return -1;
  }

  void _decrementInvoiceItemsQuantity(BuildContext context) {
    final Map<String, List<ProductModel>> itemsMap = {
      'Medicines': [],
      'Accessories': [],
    };
    // Update product items lists localy
    for (InvoiceItemModel item in invoiceInfo.items) {
      if (item.type == 'Medicines') {
        final ProductModel medicine =
            _updateInvoiceItemQuantity(item, medicinesList);
        itemsMap['Medicines']!.add(medicine);
      } else if (item.type == 'Accessories') {
        final ProductModel accessory =
            _updateInvoiceItemQuantity(item, accessoriesList);
        itemsMap['Accessories']!.add(accessory);
      }
    }
    context.read<MainCubit>().updateMedicinesList(medicinesList);
    context.read<MainCubit>().updateAccessoriesList(accessoriesList);

    // Update selable items lists in Firestore
    _updateSelableItemsListsInFirestore(itemsMap);
  }

  ProductModel _updateInvoiceItemQuantity(
      InvoiceItemModel item, List<ProductModel> itemsList) {
    final int itemIndex =
        itemsList.indexWhere((service) => service.title == item.name);
    itemsList[itemIndex] = itemsList[itemIndex].copyWith(
      quantity: itemsList[itemIndex].quantity - item.quantity,
    );
    return itemsList[itemIndex];
  }

  void _updateSelableItemsListsInFirestore(
      Map<String, List<ProductModel>> itemsMap) async {
    itemsMap.forEach((productsType, productsList) async {
      if (productsType == 'Medicines') {
        for (final medicine in productsList) {
          await _invoicesRepo.updateInvoiceProductDetails(
              clinicIndex: authData!.clinicIndex,
              collection: 'medicines',
              product: medicine);
        }
      } else if (productsType == 'Accessories') {
        for (final accessory in productsList) {
          await _invoicesRepo.updateInvoiceProductDetails(
              clinicIndex: authData!.clinicIndex,
              collection: 'accessories',
              product: accessory);
        }
      }
    });
  }

  void _setInvoiceIdentifiers() {
    invoiceInfo = invoiceInfo.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now().toString(),
    );
  }

  void _setInvoiceItemsDiscount() {
    for (int i = 0; i < invoiceInfo.items.length; i++) {
      invoiceInfo.items[i] = invoiceInfo.items[i].copyWith(
        discountPercentage: invoiceInfo.discount / invoiceInfo.total * 100,
      );
    }
  }

  bool _validateInvoiceItems() {
    for (int i = 0; i < itemFormsKeys.length; i++) {
      if (itemFormsKeys[i].currentState!.validate() &&
          invoiceInfo.items[i].name.trim() != '') {
        itemFormsKeys[i].currentState!.save();
      } else {
        emit(InvoiceConstrutingError(
          message:
              '${AppStrings.item.tr()} ${i + 1} ${AppStrings.invalidItemMessage.tr()}',
        ));
        return false;
      }
    }
    if (invoiceInfo.discount > invoiceInfo.total) {
      emit(InvoiceConstrutingError(
        message: AppStrings.discountGreaterThanTotal.tr(),
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
      return searchResult.firstWhere((element) => element!.id == invoiceId)
          as InvoiceModel;
    } catch (e) {
      return invoicesList.firstWhere((element) => element!.id == invoiceId)
          as InvoiceModel;
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
      _onSuccessOperation(AppStrings.invoiceDeletedSuccessfully.tr());
    } else {
      emit(InvoicesError(message: AppStrings.failedToDeleteInvoice.tr()));
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
      _onSuccessOperation(AppStrings.invoiceDeletedSuccessfully.tr(),
          popCount: 1);
    } catch (e) {
      emit(InvoicesError(
          message: AppStrings.failedToDeleteSelectedInvoices.tr()));
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
        discountPercentage: 0,
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
        discountPercentage: 0,
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
                  DropdownMenuEntry(
                    value: 'No items found',
                    label: AppStrings.noItemsFound.tr(),
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

  void onSaveNewInvoice(BuildContext context) {
    if (_validateInvoiceItems()) {
      addNewInvoice(context);
    }
  }

  void onSearchInvoice(String value) async {
    // Emit loading state to show loading indicator & refresh invoices
    emit(InvoicesLoading());
    value = value.toLowerCase();

    // Search invoice by date
    searchResult = await _invoicesRepo.searchInvoices(
        authData!.clinicIndex, value, 'date');

    if (value.isEmpty || searchResult.isEmpty) {
      emit(InvoicesSuccess(invoices: invoicesList));
      return;
    }

    emit(InvoicesSuccess(invoices: searchResult));
  }

  void onDeleteInvoice(
    String invoiceId,
    String enteredPassword,
  ) async {
    if (adminUser.password == enteredPassword) {
      deleteInvoice(invoiceId);
    } else {
      emit(InvoiceConstrutingError(
          message: AppStrings.adminPasswordIncorrect.tr()));
    }
  }

  void onDeleteSelectedInvoices(String enteredPassword) async {
    if (adminUser.password == enteredPassword) {
      deleteSelectedInvoices();
    } else {
      emit(InvoiceConstrutingError(
          message: AppStrings.adminPasswordIncorrect.tr()));
    }
  }

  void onPrintInvoice(String id) async {
    final invoice = getInvoiceById(id);
    await PdfInvoice.generateInvoice(PdfPageFormat.a6, invoice);
  }
}
