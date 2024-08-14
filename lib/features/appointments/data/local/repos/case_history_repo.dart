import 'package:el_sharq_clinic/features/appointments/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/appointments/data/remote/case_history_firebase_services.dart';

class CaseHistoryRepo {
  final CaseHistoryFirebaseServices _caseHistoryFirebaseServices;

  CaseHistoryRepo(this._caseHistoryFirebaseServices);

  Future<List<CaseHistoryModel>> getAllCases(int clinicIndex) async {
    return await _caseHistoryFirebaseServices.getAllCaseHistories(clinicIndex);
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
