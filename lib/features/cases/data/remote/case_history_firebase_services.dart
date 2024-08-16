import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';

class CaseHistoryFirebaseServices {
  CaseHistoryFirebaseServices(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<CaseHistoryModel>> getAllCaseHistories(int clinicIndex) async {
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    return await clinicCaseHistoryCollection.get().then((value) => value
        .docs.reversed
        .map((doc) => CaseHistoryModel.fromFirestore(doc.id, doc))
        .toList());
  }

  Future<bool> addCase(CaseHistoryModel caseHistory, int clinicIndex) async {
    // Get clinic cases document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    // Get last CaseHistory to generate new id

    final String? lastCaseHistoryId =
        await clinicCaseHistoryCollection.get().then((value) {
      try {
        return value.docs.last.id;
      } catch (e) {
        return null;
      }
    });

    final newId =
        (int.parse(lastCaseHistoryId ?? 'CSE000'.replaceAll('CSE', '')) + 1)
            .toString()
            .toId(3, prefix: 'CSE');

    // Add new CaseHistory to clinic CaseHistory collection
    try {
      await clinicCaseHistoryCollection
          .doc(newId)
          .set(caseHistory.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCase(CaseHistoryModel caseHistory, int clinicIndex) async {
    // Get clinic cases document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    // Update CaseHistory in clinic CaseHistory collection
    log('case history id: ${caseHistory}');
    log('case history id: ${caseHistory.id}');

    try {
      await clinicCaseHistoryCollection
          .doc(caseHistory.id)
          .update(caseHistory.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCase(String caseId, int clinicIndex) async {
    // Get clinic cases document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    try {
      await clinicCaseHistoryCollection.doc(caseId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getClinicDoc(
      int clinicIndex) async {
    return await _firestore
        .collection('clinics')
        .doc('clinic$clinicIndex')
        .get();
  }
}
