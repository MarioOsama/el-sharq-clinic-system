import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/cases/data/remote/case_history_firebase_services.dart';

class CaseHistoryRepo {
  final CaseHistoryFirebaseServices _caseHistoryFirebaseServices;

  CaseHistoryRepo(this._caseHistoryFirebaseServices);

  Future<List<CaseHistoryModel>> getAllCases(
      int clinicIndex, String? lastCaseId) async {
    return await _caseHistoryFirebaseServices.getAllCaseHistories(
        clinicIndex: clinicIndex, lastCaseId: lastCaseId);
  }

  Future<String?> getFirstCaseId(int clinicIndex, bool descendingOrder) async {
    return await _caseHistoryFirebaseServices.getFirstCaseId(
        clinicIndex: clinicIndex, descendingOrder: descendingOrder);
  }

  Future<bool> addNewCase(CaseHistoryModel appointment, int clinicIndex) async {
    return await _caseHistoryFirebaseServices.addCase(appointment, clinicIndex);
  }

  Future<bool> updateCase(CaseHistoryModel appointment, int clinicIndex) async {
    return await _caseHistoryFirebaseServices.updateCase(
        appointment, clinicIndex);
  }

  Future<bool> deleteCase(String appointmentId, int clinicIndex) async {
    return await _caseHistoryFirebaseServices.deleteCase(
        appointmentId, clinicIndex);
  }
}
