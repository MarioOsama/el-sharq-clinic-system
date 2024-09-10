import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/settings/data/repos/settings_repo.dart';
import 'package:flutter/material.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo _settingsRepo;
  SettingsCubit(this._settingsRepo) : super(SettingsInitial());

  // Variables
  AuthDataModel? authData;
  AuthDataModel? newAuthData;
  ValueNotifier<bool> saveButtonState = ValueNotifier<bool>(false);

  // Methods
  void setupSectionData(AuthDataModel authData) {
    this.authData = authData;
    newAuthData = authData;
  }

  void changeLanguage(String language) {
    emit(SettingsInitial());
    newAuthData = newAuthData!.copyWith(language: language);
    if (newAuthData != authData) {
      emit(SettingsUpdated());
      saveButtonState.value = true;
    }
    determineSaveButtonState();
  }

  void changeTheme(String theme) {
    emit(SettingsInitial());
    newAuthData = newAuthData!.copyWith(theme: theme);
    if (newAuthData != authData) {
      emit(SettingsUpdated());
      saveButtonState.value = true;
    }
    determineSaveButtonState();
  }

  void changeLowStockLimit(double lowStockLimit) {
    emit(SettingsInitial());
    newAuthData = newAuthData!.copyWith(lowStockLimit: lowStockLimit);
    if (newAuthData != authData) {
      emit(SettingsUpdated());
    }
    determineSaveButtonState();
  }

  void determineSaveButtonState() {
    if (newAuthData != authData) {
      saveButtonState.value = true;
    } else {
      saveButtonState.value = false;
    }
  }
}
