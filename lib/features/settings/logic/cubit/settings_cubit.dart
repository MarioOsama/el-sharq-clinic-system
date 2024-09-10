import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
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

  // UI Methods
  void changeLanguage(String language) {
    emit(SettingsInitial());
    newAuthData = newAuthData!.copyWith(language: language);
    if (newAuthData != authData) {
      emit(SettingsChanged());
      saveButtonState.value = true;
    }
    determineSaveButtonState();
  }

  void changeTheme(String theme) {
    emit(SettingsInitial());
    newAuthData = newAuthData!.copyWith(theme: theme);
    if (newAuthData != authData) {
      emit(SettingsChanged());
      saveButtonState.value = true;
    }
    determineSaveButtonState();
  }

  void changeLowStockLimit(double lowStockLimit) {
    emit(SettingsInitial());
    newAuthData = newAuthData!.copyWith(lowStockLimit: lowStockLimit);
    if (newAuthData != authData) {
      emit(SettingsChanged());
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

  void onSavePreferences(MainCubit mainCubit) async {
    try {
      // Save preferences to firestore
      await _settingsRepo.updatePreferences(newAuthData!);
    } catch (e) {
      emit(SettingsError(e.toString()));
      return;
    }
    // Update main cubit auth data
    mainCubit.updateAuthData(newAuthData!);
    saveButtonState.value = false;
    emit(SettingsUpdated());
  }
}
