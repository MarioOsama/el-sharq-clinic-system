import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/features/appointments/data/local/models/appointment_model.dart';

class AppointmentsFirebaseServices {
  AppointmentsFirebaseServices(this._firestore);

  final FirebaseFirestore _firestore;

  // Future<void> createAppointment(Appointment appointment) async {
  //   await _firestore.collection('appointments').add(appointment.toMap());
  // }

  // Future<void> updateAppointment(Appointment appointment) async {
  //   await _firestore
  //       .collection('appointments')
  //       .doc(appointment.id)
  //       .update(appointment.toMap());
  // }

  // Future<void> deleteAppointment(String appointmentId) async {
  //   await _firestore.collection('appointments').doc(appointmentId).delete();
  // }

  // Stream<List<Appointment>> getAppointments() {
  //   return _firestore.collection('appointments').snapshots().map((snapshot) =>
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

  Future<bool> addAppointment(
      AppointmentModel appointment, int clinicIndex) async {
    // Get clinic appointment document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicAppointmentCollection =
        clinicDoc.reference.collection('appointments');
    // Get last appointment to generate new id
    final lastAppointment = await clinicAppointmentCollection
        .get()
        .then((value) => value.docs.last);
    final newId = (int.parse(lastAppointment.id.replaceAll('APT', '')) + 1)
        .toString()
        .toId(3, prefix: 'APT');

    // Add new appointment to clinic appointment collection
    try {
      await clinicAppointmentCollection
          .doc(newId)
          .set(appointment.toFirestore());
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
