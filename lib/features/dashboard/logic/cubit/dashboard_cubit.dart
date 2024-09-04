import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/dashboard/data/repos/dashboard_repo.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:intl/intl.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepo _dashboardRepo;
  DashboardCubit(this._dashboardRepo) : super(DashboardInitial());

  AuthDataModel? authData;

  void setupSectionData(AuthDataModel authData) async {
    setAuthData(authData);
    final int todayCasesCount = await getTodayCasesCount();
    final int todayOwnersCount = await getTodayRegisteredOwnersCount();
    final List<InvoiceModel> lastWeekInvoices = await getLastWeekInvoices();
    final List<InvoiceModel> todayInvoices = getTodayInvoices(lastWeekInvoices);
    final List<InvoiceItemModel> lastWeekPopularItems =
        getLastWeekPopularItems(lastWeekInvoices);
    final List<CaseHistoryModel> cases = await getLastWeekCases();
    final List<ProductModel> lowStockProducts = await getLowStockProducts();
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
      'Services': 0,
      'Medicines': 0,
      'Accessories': 0,
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

  Future<List<ProductModel>> getLowStockProducts() async {
    return await _dashboardRepo.getLowStockProducts(authData!.clinicIndex, 5);
  }
}
