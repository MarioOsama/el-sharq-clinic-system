part of 'invoices_cubit.dart';

abstract class InvoicesState {
  void takeAction(BuildContext context) {}
}

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

final class InvoiceConstruting extends InvoicesState {
  final InvoiceModel invoiceModel;

  InvoiceConstruting({required this.invoiceModel});
}

final class InvoiceConstrutingError extends InvoicesState {
  final String message;

  InvoiceConstrutingError({required this.message});
}

final class InvoiceItemTypeChanged extends InvoicesState {
  final int index;
  final String type;
  InvoiceItemTypeChanged({required this.index, required this.type});
}

final class InvoiceInProgress extends InvoicesState {
  @override
  void takeAction(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: AnimatedLoadingIndicator());
        });
  }
}

final class InvoiceSuccessOperation extends InvoicesState {
  final String message;
  final int popCount;
  InvoiceSuccessOperation({required this.message, this.popCount = 1});

  @override
  void takeAction(BuildContext context) {
    super.takeAction(context);
    for (var i = 0; i < popCount; i++) {
      context.pop();
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Success',
        content: message,
        dialogType: DialogType.success,
      ),
    );
    // Hide success dialog after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }
}
