import 'dart:developer';

import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';

class DoctorsRepo {
  final FirebaseServices _firebaseServices;

  DoctorsRepo(this._firebaseServices);

  final String collectionName = 'doctors';

  Future<List<DoctorModel>> getDoctors(
      int clinicIndex, String? lastOwnerId) async {
    try {
      return _firebaseServices.getItems<DoctorModel>(collectionName,
          clinicIndex: clinicIndex,
          fromFirestore: DoctorModel.fromFirestore,
          lastId: lastOwnerId);
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<String?> getLastOwnerId(int clinicIndex, bool decsendingOrder) {
    return _firebaseServices.getFirstItemId(collectionName,
        clinicIndex: clinicIndex, descendingOrder: decsendingOrder);
  }
}
