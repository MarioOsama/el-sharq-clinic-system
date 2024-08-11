import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/features/data/local/models/user_model.dart';
import 'package:el_sharq_clinic/features/data/local/repos/auth_repo.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  String selectedClinic = 'Select Clinic';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void selectClinic(String clinic) {
    selectedClinic = clinic;
    emit(AuthInitial());
  }

  void openSystem() async {
    if (validatedInputs()) {
      emit(AuthLoading());
      await _authRepo
          .openWithUserNameAndPassword(
              AppConstant.clinicsList.indexOf(selectedClinic),
              usernameController.text,
              passwordController.text)
          .then(
        (value) {
          if (value != null) {
            emit(AuthSuccess(value.data()));
            return value.data();
          }
          emit(AuthFailure('Invalid username or password'));
          return null;
        },
      );
    }
  }

  bool validatedInputs() {
    if (selectedClinic == 'Select Clinic') {
      emit(AuthFailure('Please select a clinic'));
      return false;
    } else if (usernameController.text.trim().isEmpty) {
      emit(AuthFailure('Please enter a username'));
      return false;
    } else if (passwordController.text.trim().isEmpty ||
        passwordController.text.length < 6) {
      emit(AuthFailure('Please enter a password'));
      return false;
    }
    return true;
  }
}
