import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/features/appointments/data/local/models/appointment_model.dart';

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

  Future<QuerySnapshot<T>> _getNestedCollection<T>(
      DocumentSnapshot<Object?> doc,
      String collectionName,
      T Function(DocumentSnapshot<Map<String, dynamic>> snapshot) fromFirestore,
      Map<String, dynamic> Function(T object) toFirestore) async {
    return await doc.reference
        .collection(collectionName)
        .withConverter<T>(
          fromFirestore: (snapshot, options) => fromFirestore(snapshot),
          toFirestore: (value, options) => toFirestore(value),
        )
        .get();
  }

  Future<bool> addCase(CaseHistoryModel caseHistory, int clinicIndex) async {
    // Get clinic appointment document
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

  Future<DocumentSnapshot<Map<String, dynamic>>> _getClinicDoc(
      int clinicIndex) async {
    return await _firestore
        .collection('clinics')
        .doc('clinic$clinicIndex')
        .get();
  }
}
