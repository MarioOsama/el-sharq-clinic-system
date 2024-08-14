import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/features/appointments/data/local/models/case_history_model.dart';

class CaseHistoryFirebaseServices {
  CaseHistoryFirebaseServices(this._firestore);

  final FirebaseFirestore _firestore;

  // Future<void> createAppointment(Appointment appointment) async {
  //   await _firestore.collection('CaseHistory').add(appointment.toMap());
  // }

  // Future<void> updateAppointment(Appointment appointment) async {
  //   await _firestore
  //       .collection('CaseHistory')
  //       .doc(appointment.id)
  //       .update(appointment.toMap());
  // }

  // Future<void> deleteAppointment(String appointmentId) async {
  //   await _firestore.collection('CaseHistory').doc(appointmentId).delete();
  // }

  // Stream<List<Appointment>> getCaseHistory() {
  //   return _firestore.collection('CaseHistory').snapshots().map((snapshot) =>
  //       snapshot.docs
  //           .map((doc) => Appointment.fromMap(doc.id, doc.data()))
  //           .toList());
  // }

  Future<List<CaseHistoryModel>> getAllCaseHistories(int clinicIndex) async {
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    return await clinicCaseHistoryCollection.get().then((value) => value.docs
        .map((doc) => CaseHistoryModel.fromFirestore(doc.id, doc))
        .toList());
  }

  Future<bool> addCase(CaseHistoryModel caseHistory, int clinicIndex) async {
    // Get clinic cases document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    // Get last CaseHistory to generate new id
    final lastCaseHistory = await clinicCaseHistoryCollection
        .get()
        .then((value) => value.docs.last);
    final newId = (int.parse(lastCaseHistory.id.replaceAll('CSE', '')) + 1)
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
