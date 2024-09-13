import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/dashboard/data/repos/dashboard_repo.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepo _dashboardRepo;
  DashboardCubit(this._dashboardRepo) : super(DashboardInitial());

  AuthDataModel? authData;

  void setupSectionData(AuthDataModel authData, MainCubit mainCubit) async {
    setAuthData(authData);
    try {
      final int todayCasesCount = await getTodayCasesCount();
      final int todayOwnersCount = await getTodayRegisteredOwnersCount();
      final List<InvoiceModel> lastWeekInvoices = await getLastWeekInvoices();
      final List<InvoiceModel> todayInvoices =
          getTodayInvoices(lastWeekInvoices);
      final List<InvoiceItemModel> lastWeekPopularItems =
          getLastWeekPopularItems(lastWeekInvoices);
      final List<CaseHistoryModel> cases = await getLastWeekCases();
      final List<List<SelableItemModel>> selableItemsList =
          await _setupSelableItemsListsData(mainCubit);
      final List<ProductModel> lowStockProducts = getLowStockProducts([
        ...selableItemsList[1].cast<ProductModel>(),
        ...selableItemsList[2].cast<ProductModel>(),
      ]);
      emit(DashboardSuccess(
        todayCasesCount: todayCasesCount,
        todayOwnersCount: todayOwnersCount,
        todayInvoicesCount: todayInvoices.length,
        todayInvoicesTotal: _getInvoicesTotal(todayInvoices),
        todayRevenue: _getTodayRevenue(todayInvoices),
        todaySalesMap: _getTodaySalesCategories(todayInvoices),
        weeklyCasesMap: _getWeeklyCasesMap(cases),
        popularItems: lastWeekPopularItems,
        lowStockProducts: lowStockProducts,
      ));
    } catch (e) {
      emit(DashboardError(message: AppStrings.someThingWentWrong.tr()));
    }
  }

  Future<List<List<SelableItemModel>>> _setupSelableItemsListsData(
      MainCubit mainCubit) async {
    if (mainCubit.isSelableItemListsLoaded == false) {
      final List<List<SelableItemModel>> selableItemsList =
          await loadSelableItemsLists();
      updateSelableItemsListsInMainCubit(
          mainCubit,
          selableItemsList[0].cast<ServiceModel>(),
          selableItemsList[1].cast<ProductModel>(),
          selableItemsList[2].cast<ProductModel>());
      mainCubit.isSelableItemListsLoaded = true;
      return selableItemsList;
    }
    return [
      mainCubit.servicesList,
      mainCubit.medicinesList,
      mainCubit.accessorieList
    ];
  }

  Future<List<List<SelableItemModel>>> loadSelableItemsLists() async {
    return await _dashboardRepo.loadSelableItemsLists(authData!.clinicIndex);
  }

  void updateSelableItemsListsInMainCubit(
      MainCubit cubit,
      List<ServiceModel> servicesList,
      List<ProductModel> medicinesList,
      List<ProductModel> accessoriesList) {
    cubit.updateServicesList(servicesList);
    cubit.updateMedicinesList(medicinesList);
    cubit.updateAccessoriesList(accessoriesList);
  }

  void setAuthData(AuthDataModel authData) {
    this.authData = authData;
  }

  Future<int> getTodayCasesCount() async {
    return await _dashboardRepo.getTodayCases(authData!.clinicIndex);
  }

  Future<int> getTodayRegisteredOwnersCount() async {
    return await _dashboardRepo.getTodayOwners(authData!.clinicIndex);
  }

  Future<List<InvoiceModel>> getLastWeekInvoices() async {
    return await _dashboardRepo.getLastWeekInvoices(authData!.clinicIndex);
  }

  List<InvoiceModel> getTodayInvoices(List<InvoiceModel> lastWeekInvoices) {
    return lastWeekInvoices
        .where((invoice) =>
            invoice.date.substring(0, 10) ==
            DateTime.now().toString().substring(0, 10))
        .toList();
  }

  double _getInvoicesTotal(List<InvoiceModel> invoices) {
    double total = 0;
    for (var element in invoices) {
      total += element.total;
    }
    return total;
  }

  double _getTodayRevenue(List<InvoiceModel> invoices) {
    double revenue = 0;
    for (var element in invoices) {
      revenue += element.total - element.discount;
    }
    return revenue;
  }

  Map<String, double> _getTodaySalesCategories(List<InvoiceModel> invoices) {
    final Map<String, double> salesMap = {
      AppStrings.services.tr(): 0,
      AppStrings.medicines.tr(): 0,
      AppStrings.accessories.tr(): 0,
    };
    for (var invoice in invoices) {
      final double invoiceDiscountPercentage = invoice.discount / invoice.total;
      for (var item in invoice.items) {
        final double itemPrice = item.price * item.quantity;
        salesMap[item.type] = (salesMap[item.type] ?? 0) +
            itemPrice -
            invoiceDiscountPercentage * itemPrice;
      }
    }
    return salesMap;
  }

  List<InvoiceItemModel> getLastWeekPopularItems(
      List<InvoiceModel> lastWeekInvoices) {
    List<InvoiceItemModel> popularItems = [];
    for (final invoice in lastWeekInvoices) {
      final double invoiceDiscountPercentage = invoice.discount / invoice.total;
      for (final item in invoice.items) {
        if (popularItems
            .where((element) => element.name == item.name)
            .isEmpty) {
          popularItems.add(item);
        } else {
          double elementQuantity = 0;
          int itemIndex = popularItems.indexWhere((element) {
            return element.name == item.name;
          });
          elementQuantity = popularItems[itemIndex].quantity;
          popularItems[itemIndex] = popularItems[itemIndex].copyWith(
            quantity: elementQuantity + item.quantity,
            price: item.price - invoiceDiscountPercentage * item.price,
          );
        }
      }
    }

    popularItems.sort((a, b) => b.quantity.compareTo(a.quantity));
    return popularItems;
  }

  Future<List<CaseHistoryModel>> getLastWeekCases() async {
    return await _dashboardRepo.getLastWeekCases(authData!.clinicIndex);
  }

  Map<String, int> _getWeeklyCasesMap(List<CaseHistoryModel> cases) {
    final Map<String, int> casesMap = {
      'Sunday': 0,
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0
    };
    for (var element in cases) {
      final DateTime date = DateTime(
          int.parse(element.date.substring(0, 4)),
          int.parse(element.date.substring(5, 7)),
          int.parse(element.date.substring(8, 10)));
      String day = DateFormat('EEEE').format(date);
      casesMap[day] = (casesMap[day] ?? 0) + 1;
    }
    return casesMap;
  }

  List<ProductModel> getLowStockProducts(List<ProductModel> products) {
    return products
        .where((product) => product.quantity <= authData!.lowStockLimit)
        .toList();
  }
}
