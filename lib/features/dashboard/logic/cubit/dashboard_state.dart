part of 'dashboard_cubit.dart';

abstract class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardSuccess extends DashboardState {
  final int todayCasesCount;
  final int todayOwnersCount;
  final int todayInvoicesCount;
  final double todayInvoicesTotal;
  final double todayRevenue;
  final Map<String, double> todaySalesMap;
  final Map<String, int> weeklyCasesMap;
  final List<InvoiceItemModel> popularItems;
  final List<ProductModel> lowStockProducts;

  DashboardSuccess({
    required this.todayCasesCount,
    required this.todayOwnersCount,
    required this.todayInvoicesCount,
    required this.todayInvoicesTotal,
    required this.todayRevenue,
    required this.todaySalesMap,
    required this.weeklyCasesMap,
    required this.popularItems,
    required this.lowStockProducts,
  });
}

final class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}
