import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/core/networking/firebase_services.dart';

class CaseHistoryRepo {
  final FirebaseServices _firebaseServices;

  CaseHistoryRepo(this._firebaseServices);

  final String collectionName = 'cases';

  Future<List<CaseHistoryModel>> getAllCases(
      int clinicIndex, String? lastCaseId) async {
    return await _firebaseServices.getItems<CaseHistoryModel>(
      collectionName,
      clinicIndex: clinicIndex,
      fromFirestore: CaseHistoryModel.fromFirestore,
      lastId: lastCaseId,
    );
  }

  Future<String?> getFirstCaseId(int clinicIndex, bool descendingOrder) async {
    return await _firebaseServices.getFirstItemId(
      collectionName,
      clinicIndex: clinicIndex,
      descendingOrder: descendingOrder,
    );
  }

  Future<bool> addNewCase(CaseHistoryModel caseModel, int clinicIndex) async {
    return await _firebaseServices.addItem<CaseHistoryModel>(
      collectionName,
      itemModel: caseModel,
      id: caseModel.id,
      clinicIndex: clinicIndex,
      toFirestore: caseModel.toFirestore,
      idScheme: 'CSE',
    );
  }

  Future<bool> updateCase(CaseHistoryModel caseModel, int clinicIndex) async {
    return await _firebaseServices.updateItem<CaseHistoryModel>(
      collectionName,
      itemModel: caseModel,
      clinicIndex: clinicIndex,
      toFirestore: caseModel.toFirestore,
      id: caseModel.id,
    );
  }

  Future<bool> deleteCase(String caseId, int clinicIndex) async {
    return await _firebaseServices.deleteItem(
      collectionName,
      id: caseId,
      clinicIndex: clinicIndex,
    );
  }
}
