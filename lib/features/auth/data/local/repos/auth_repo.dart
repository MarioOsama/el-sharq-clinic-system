import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';
import 'package:el_sharq_clinic/features/auth/data/remote/auth_firebase_services.dart';

class AuthRepo {
  final AuthFirebaseServices _authFirebaseServices;

  AuthRepo(this._authFirebaseServices);

  Future<QueryDocumentSnapshot<UserModel>?> openWithUserNameAndPassword(
      int clinicIndex, String userName, String password) async {
    return await _authFirebaseServices.openWithUserNameAndPassword(
        clinicIndex, userName, password);
  }
}
