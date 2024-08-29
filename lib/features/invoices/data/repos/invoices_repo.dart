import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';

class InvoicesRepo {
  final FirebaseServices _firebaseServices;

  InvoicesRepo(this._firebaseServices);

  final String collectionName = 'invoices';

  Future<List<InvoiceModel>> getInvoices(
      int clinicIndex, String? lastInvoiceId) async {
    return _firebaseServices.getItems<InvoiceModel>(
      collectionName,
      clinicIndex: clinicIndex,
      fromFirestore: InvoiceModel.fromFirestore,
      lastId: lastInvoiceId,
    );
  }
}
