import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';

class DoctorsRepo {
  final FirebaseServices _firebaseServices;

  DoctorsRepo(this._firebaseServices);

  final String collectionName = 'doctors';

  Future<List<DoctorModel>> getDoctors(
      int clinicIndex, String? lastDoctorId) async {
    return _firebaseServices.getItems<DoctorModel>(collectionName,
        clinicIndex: clinicIndex,
        fromFirestore: DoctorModel.fromFirestore,
        lastId: lastDoctorId);
  }

  Future<String?> getFirstDoctorId(int clinicIndex, bool decsendingOrder) {
    return _firebaseServices.getFirstItemId(collectionName,
        clinicIndex: clinicIndex, descendingOrder: decsendingOrder);
  }

  Future<bool> addDoctor(DoctorModel doctor, String id, int clinicIndex) async {
    await _firebaseServices.addItem(collectionName,
        clinicIndex: clinicIndex,
        itemModel: doctor,
        id: id,
        toFirestore: doctor.toFirestore);
    return true;
  }

  Future<bool> updateDoctor(DoctorModel doctor, int clinicIndex) async {
    await _firebaseServices.updateItem(collectionName,
        clinicIndex: clinicIndex,
        itemModel: doctor,
        id: doctor.id,
        toFirestore: doctor.toFirestore);
    return true;
  }

  Future<bool> deleteDoctor(int clinicIndex, String doctorId) async {
    await _firebaseServices.deleteItem(collectionName,
        id: doctorId, clinicIndex: clinicIndex);
    return true;
  }

  Future<List<DoctorModel>> searchDoctors(
      int clinicIndex, String name, String field) async {
    return _firebaseServices.getItemsByField<DoctorModel>(collectionName,
        clinicIndex: clinicIndex,
        value: name,
        field: field,
        fromFirestore: DoctorModel.fromFirestore);
  }
}
