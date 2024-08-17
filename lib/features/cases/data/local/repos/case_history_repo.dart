import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/core/networking/firebase_services.dart';

class CaseHistoryRepo {
  final FirebaseServices _caseHistoryFirebaseServices;

  CaseHistoryRepo(this._caseHistoryFirebaseServices);

  Future<List<CaseHistoryModel>> getAllCases(
      int clinicIndex, String? lastCaseId) async {
    return await _caseHistoryFirebaseServices.getItems<CaseHistoryModel>(
      'cases',
      clinicIndex: clinicIndex,
      fromFirestore: CaseHistoryModel.fromFirestore,
      lastId: lastCaseId,
    );
  }

  Future<String?> getFirstCaseId(int clinicIndex, bool descendingOrder) async {
    return await _caseHistoryFirebaseServices.getFirstItemId(
      'cases',
      clinicIndex: clinicIndex,
      descendingOrder: descendingOrder,
    );
  }

  Future<bool> addNewCase(CaseHistoryModel caseModel, int clinicIndex) async {
    return await _caseHistoryFirebaseServices.addItem<CaseHistoryModel>(
      'cases',
      itemModel: caseModel,
      clinicIndex: clinicIndex,
      toFirestore: caseModel.toFirestore,
      idScheme: 'CSE',
    );
  }

  Future<bool> updateCase(CaseHistoryModel caseModel, int clinicIndex) async {
    return await _caseHistoryFirebaseServices.updateItem<CaseHistoryModel>(
      'cases',
      itemModel: caseModel,
      clinicIndex: clinicIndex,
      toFirestore: caseModel.toFirestore,
      id: caseModel.id!,
    );
  }

  Future<bool> deleteCase(String caseId, int clinicIndex) async {
    return await _caseHistoryFirebaseServices.deleteItem(
      'cases',
      id: caseId,
      clinicIndex: clinicIndex,
    );
  }
}
