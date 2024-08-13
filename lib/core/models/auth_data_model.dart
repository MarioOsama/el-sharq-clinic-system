import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';

class AuthDataModel {
  final UserModel userModel;
  final int clinicIndex;
  final String clinicName;

  AuthDataModel(
      {required this.clinicIndex,
      required this.userModel,
      required this.clinicName});
}
