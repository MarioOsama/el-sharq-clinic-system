import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_model.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/owner_model.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';

class DashboardRepo {
  final FirebaseServices _firebaseServices;

  DashboardRepo(this._firebaseServices);

  Future<int> getTodayCases(int clinicIndex) async {
    try {
      return await _firebaseServices
          .getDocsByStringDate<CaseHistoryModel>(
            'cases',
            clinicIndex: clinicIndex,
            fromFirestore: CaseHistoryModel.fromFirestore,
            dateField: 'date',
            stringStartDate: DateTime.now().toString().substring(0, 10),
          )
          .then((value) => value.length);
    } catch (e) {
      return -1;
    }
  }

  Future<int> getTodayOwners(int clinicIndex) async {
    try {
      return await _firebaseServices
          .getDocsByDate<OwnerModel>(
            'owners',
            clinicIndex: clinicIndex,
            fromFirestore: OwnerModel.fromFirestore,
            dateField: 'registrationDate',
            startDate: DateTime.now(),
          )
          .then((value) => value.length);
    } catch (e) {
      return -1;
    }
  }

  Future<List<InvoiceModel>> getLastWeekInvoices(int clinicIndex) async {
    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(const Duration(days: 7));
    return await _firebaseServices.getDocsByDate(
      'invoices',
      clinicIndex: clinicIndex,
      dateField: 'date',
      startDate: startDate,
      fromFirestore: InvoiceModel.fromFirestore,
      endDate: now,
    );
  }

  Future<List<CaseHistoryModel>> getLastWeekCases(int clinicIndex) async {
    DateTime now = DateTime.now();
    int currentWeekDay = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekDay % 7));
    return await _firebaseServices.getDocsByStringDate(
      'cases',
      clinicIndex: clinicIndex,
      dateField: 'date',
      stringStartDate: startOfWeek.toString(),
      fromFirestore: CaseHistoryModel.fromFirestore,
      stringEndDate: now.toString(),
    );
  }

  Future<List<ProductModel>> getLowStockProducts(
      int clinicIndex, int limitValue) async {
    List<List<ProductModel>> results = await Future.wait(
      [
        _firebaseServices.getItemsEqualOrLessValue<ProductModel>(
          'medicines',
          clinicIndex: clinicIndex,
          field: 'quantity',
          value: limitValue,
          fromFirestore: ProductModel.fromFirestore,
        ),
        _firebaseServices.getItemsEqualOrLessValue<ProductModel>(
          'accessories',
          clinicIndex: clinicIndex,
          field: 'quantity',
          value: limitValue,
          fromFirestore: ProductModel.fromFirestore,
        ),
      ],
    );

    return results.expand((x) => x).toList();
  }
}
