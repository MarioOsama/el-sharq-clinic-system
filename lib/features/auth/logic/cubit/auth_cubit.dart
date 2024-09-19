import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/routing/app_routes.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/auth/data/local/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  String selectedClinic = AppStrings.selectClinic.tr();
  List<String> clinicNames = [AppStrings.selectClinic.tr()];
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void setupInitialData() async {
    if (clinicNames.length <= 1) {
      try {
        final loadedClinicNames = await _authRepo.getAllClinicNames();
        clinicNames.addAll(loadedClinicNames);
      } catch (e) {
        emit(AuthFailure(AppStrings.clinicDataLoadError.tr()));
      }
    }

    emit(AuthInitial());
  }

  void selectClinic(String clinic) {
    selectedClinic = clinic;
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
            emit(AuthSuccess(
              value,
            ));
          } else {
            emit(AuthFailure(
              AppStrings.invalidUserInfo.tr(),
            ));
          }
        },
      );
    }
  }

  bool validatedInputs() {
    if (selectedClinic == AppStrings.selectClinic.tr()) {
      emit(AuthFailure(AppStrings.invalidClinic.tr()));
      return false;
    } else if (usernameController.text.trim().isEmpty) {
      emit(AuthFailure(AppStrings.invalidUsername.tr()));
      return false;
    } else if (passwordController.text.trim().isEmpty ||
        passwordController.text.length < 6) {
      emit(AuthFailure(AppStrings.invalidPassword.tr()));

      return false;
    }
    return true;
  }
}
