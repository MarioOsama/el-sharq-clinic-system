import 'package:el_sharq_clinic/core/logic/general_repo.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';

class CasesRepo extends GeneralRepo<CaseHistoryModel> {
  CasesRepo(super.firebaseServices, super.collectionName);

  Future<List<CaseHistoryModel>> getAllCases(
      int clinicIndex, String? lastCaseId) async {
    return getAllItems(clinicIndex, lastCaseId, CaseHistoryModel.fromFirestore);
  }

  Future<String?> getFirstCaseId(int clinicIndex, bool descendingOrder) async {
    return getFirstItemId(clinicIndex, descendingOrder);
  }

  Future<bool> addNewCase(CaseHistoryModel caseModel, int clinicIndex) async {
    return addNewItem(caseModel, clinicIndex);
  }

  Future<bool> updateCase(CaseHistoryModel caseModel, int clinicIndex) async {
    return updateItem(caseModel, clinicIndex);
  }

  Future<bool> deleteCase(String caseId, int clinicIndex) async {
    return deleteItem(caseId, clinicIndex);
  }

  Future<List<CaseHistoryModel>> searchCases(
      int clinicIndex, String value, String field) async {
    return searchItems(clinicIndex, value, field);
  }

  Future<List<DoctorModel>> getAllDoctors(int clinicIndex) async {
    return await firebaseServices.getItems<DoctorModel>(
      'doctors',
      clinicIndex: clinicIndex,
      fromFirestore: DoctorModel.fromFirestore,
      limit: -1,
    );
  }
}
