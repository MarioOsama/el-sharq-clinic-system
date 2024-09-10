import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/auth/data/remote/auth_firebase_services.dart';

class SettingsRepo {
  final AuthFirebaseServices _authFirebaseServices;

  SettingsRepo(this._authFirebaseServices);

  Future<void> updatePreferences(AuthDataModel authData) async {
    await _authFirebaseServices.updatePreferences(authData);
  }
}
