import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';
import 'package:el_sharq_clinic/features/auth/data/remote/auth_firebase_services.dart';

class SettingsRepo {
  final AuthFirebaseServices _authFirebaseServices;

  SettingsRepo(this._authFirebaseServices);

  Future<void> updatePreferences(AuthDataModel authData) async {
    await _authFirebaseServices.updatePreferences(authData);
  }

  Future<void> updateUserPassword(
      AuthDataModel authData, String newPassword) async {
    await _authFirebaseServices.updateUserPassword(authData, newPassword);
  }

  Future<void> addUserAccount(UserModel newUser, AuthDataModel authData) async {
    await _authFirebaseServices.addUserAccount(authData, newUser);
  }

  Future<void> deleteUserAccount(AuthDataModel authData, String userId) async {
    await _authFirebaseServices.deleteUserAccount(authData, userId);
  }

  Future<List<UserModel>> getClinicUsers(AuthDataModel authData) async {
    return await _authFirebaseServices.getClinicUsers(authData);
  }
}
