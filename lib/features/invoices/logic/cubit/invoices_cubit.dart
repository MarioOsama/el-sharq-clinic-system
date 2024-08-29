import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/repos/invoices_repo.dart';
import 'package:flutter/material.dart';

part 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  final InvoicesRepo _invoicesRepo;
  InvoicesCubit(this._invoicesRepo) : super(InvoicesInitial());

  // Variables
  AuthDataModel? authData;
  ValueNotifier<int> numberOfItems = ValueNotifier(1);
  List<GlobalKey<FormState>> itemFormsKeys = [GlobalKey<FormState>()];

  final List<InvoiceModel> invoicesList = [];
  List<bool> selectedRows = [];
  List<InvoiceModel> itemsList = [];

  int pageLength = 10;

  // Functions
  void setupSectionData(AuthDataModel authenticationData) {
    _setAuthData(authenticationData);
    _getPaginatedInvoices();
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

  // void getNextPage(int firstIndex) async {
  //   String? lastInvoiceId = InvoicesList.lastOrNull?.id;
  //   final String? lastInvoiceIdInFirestore = await getFirstInvoiceId();
  //   final bool isLastPage = InvoicesList.length - firstIndex <= pageLength;
  //   if (lastInvoiceIdInFirestore.toString() != lastInvoiceId.toString() &&
  //       isLastPage) {
  //     try {
  //       final List<InvoiceModel> newInvoicesList =
  //           await _InvoicesRepo.getInvoices(authData!.clinicIndex, lastInvoiceId);
  //       InvoicesList.addAll(newInvoicesList);
  //       selectedRows = List.filled(InvoicesList.length, false);
  //       emit(InvoicesSuccess(Invoices: InvoicesList));
  //     } catch (e) {
  //       emit(InvoicesError('Failed to get the Invoices'));
  //     }
  //   }
  // }
}
