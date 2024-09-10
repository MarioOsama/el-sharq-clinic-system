import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/auth/data/remote/auth_firebase_services.dart';

class AuthRepo {
  final AuthFirebaseServices _authFirebaseServices;

  AuthRepo(this._authFirebaseServices);

  Future<AuthDataModel?> openWithUserNameAndPassword(
      int clinicIndex, String userName, String password) async {
    return await _authFirebaseServices.openWithUserNameAndPassword(
        clinicIndex, userName, password);
  }
}
