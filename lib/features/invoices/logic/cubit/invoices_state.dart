part of 'invoices_cubit.dart';

abstract class InvoicesState {}

final class InvoicesInitial extends InvoicesState {}

final class InvoicesLoading extends InvoicesState {}

final class InvoicesSuccess extends InvoicesState {
  final List<InvoiceModel?> invoices;

  InvoicesSuccess({required this.invoices});
}

final class InvoicesError extends InvoicesState {
  final String message;

  InvoicesError({required this.message});
}

final class InvoiceItemsChanged extends InvoicesState {
  final int numberOfItems;

  InvoiceItemsChanged({required this.numberOfItems});
}

final class InvoiceItemTypeChanged extends InvoicesState {
  final int index;
  final String type;
  InvoiceItemTypeChanged({required this.index, required this.type});
}
