import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/auth/data/local/repos/auth_repo.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  String selectedClinic = 'Select Clinic';
  List<String> clinicNames = ['Select Clinic'];
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void setupInitialData() async {
    if (clinicNames.length <= 1) {
      try {
        final loadedClinicNames = await _authRepo.getAllClinicNames();
        clinicNames.addAll(loadedClinicNames);
      } catch (e) {
        emit(AuthFailure('Failed to load clinics data'));
      }
    }

    emit(AuthInitial());
  }

  void selectClinic(String clinic) {
    selectedClinic = clinic;
    log(selectedClinic);
    emit(AuthInitial());
  }

  void openSystem() async {
    if (validatedInputs()) {
      emit(AuthLoading());
      await _authRepo
          .openWithUserNameAndPassword(clinicNames.indexOf(selectedClinic),
              usernameController.text, passwordController.text)
          .then(
        (value) {
          if (value != null) {
            log(value.toString());
            emit(AuthSuccess(
              value,
            ));
          } else {
            emit(AuthFailure(
                'Invalid username or password for the selected clinic'));
          }
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
      emit(AuthFailure('Please enter a password with at least 6 characters'));

      return false;
    }
    return true;
  }
}
