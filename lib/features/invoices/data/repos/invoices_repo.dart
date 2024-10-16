import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';

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

  Future<bool> addNewInvoice(int clinicIndex, InvoiceModel invoiceModel) async {
    return _firebaseServices.addItem<InvoiceModel>(
      collectionName,
      id: invoiceModel.id,
      clinicIndex: clinicIndex,
      itemModel: invoiceModel,
      toFirestore: invoiceModel.toFirestore,
    );
  }

  Future<bool> deleteInvoice(int clinicIndex, String id) async {
    return _firebaseServices.deleteItem(
      collectionName,
      id: id,
      clinicIndex: clinicIndex,
    );
  }

  Future<String?> getLastInvoiceId(
      int clinicIndex, bool descendingOrder) async {
    return _firebaseServices.getFirstItemId(
      collectionName,
      clinicIndex: clinicIndex,
      descendingOrder: descendingOrder,
    );
  }

  Future<bool> updateInvoiceProductDetails(
      {required int clinicIndex,
      required String collection,
      required ProductModel product}) async {
    return _firebaseServices.updateItem(
      collection,
      clinicIndex: clinicIndex,
      itemModel: product,
      id: product.id,
      toFirestore: product.toFirestore,
    );
  }

  Future<List<InvoiceModel>> searchInvoices(
      int clinicIndex, String value, String field) async {
    final date = DateTime.tryParse(value);
    if (date != null) {
      return _firebaseServices.getDocsByDate<InvoiceModel>(
        collectionName,
        clinicIndex: clinicIndex,
        dateField: 'date',
        startDate: date,
        fromFirestore: InvoiceModel.fromFirestore,
      );
    } else {
      return [];
    }
  }

  Future<UserModel> getAdminUser(int clinicIndex) async {
    return _firebaseServices.getAdminUser(clinicIndex);
  }
}
