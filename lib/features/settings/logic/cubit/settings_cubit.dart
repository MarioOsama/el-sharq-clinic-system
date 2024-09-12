import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';
import 'package:el_sharq_clinic/features/settings/data/repos/settings_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo _settingsRepo;
  SettingsCubit(this._settingsRepo) : super(SettingsInitial());

  // Variables
  AuthDataModel? authData;
  AuthDataModel? newAuthData;
  ValueNotifier<bool> saveButtonState = ValueNotifier<bool>(false);
  List<UserModel> clinicUsers = [];

  // Methods
  void setupSectionData(AuthDataModel authData) async {
    this.authData = authData;
    newAuthData = authData;
    await getClinicUsers(authData);
  }

  Future<void> getClinicUsers(AuthDataModel authData) async {
    emit(SettingsLoading());
    try {
      clinicUsers = await _settingsRepo.getClinicUsers(authData);
      emit(SettingsInitial());
    } catch (e) {
      emit(SettingsError('Failed to get users'));
    }
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
      emit(SettingsLoading());
      // Save preferences to firestore
      await _settingsRepo.updatePreferences(newAuthData!);
    } catch (e) {
      emit(SettingsUpdatingError('Failed to update preferences'));
      return;
    }
    authData = newAuthData;
    emit(SettingsUpdated(
        authData: newAuthData!,
        message: 'Preferences updated successfully',
        popCount: 0));
    saveButtonState.value = false;
  }

  void onChangePassword(String password, String newPassword) async {
    if (newPassword.trim().length < 6) {
      emit(SettingsUpdatingError("Password must be at least 6 characters long",
          popCount: 0));
      return;
    } else {
      if (password == authData!.userModel.password) {
        try {
          emit(SettingsLoading());
          await _settingsRepo.updateUserPassword(newAuthData!, newPassword);
          newAuthData = newAuthData!.copyWith(
              userModel:
                  newAuthData!.userModel.copyWith(password: newPassword));
          emit(SettingsUpdated(
              authData: newAuthData!,
              message: 'Password updated successfully'));
        } catch (e) {
          emit(SettingsUpdatingError('Failed to update password'));
        }
      } else {
        emit(SettingsUpdatingError("The current password is incorrect",
            popCount: 0));
      }
    }
  }

  void onClinicNameChanged(String clinicName) {
    if (clinicName.trim() == newAuthData!.clinicName) return;
    if (clinicName.trim().isEmpty) {
      emit(SettingsUpdatingError('Clinic name cannot be empty', popCount: 0));
      return;
    }
    try {
      emit(SettingsLoading());
      newAuthData = newAuthData!.copyWith(clinicName: clinicName);
      _settingsRepo.updatePreferences(newAuthData!);
      emit(SettingsUpdated(
          authData: newAuthData!, message: 'Clinic name updated successfully'));
    } catch (e) {
      emit(SettingsUpdatingError('Failed to update clinic name'));
    }
  }

  void onAccountAdded(String accountName, String password) async {
    if (accountName.trim().isEmpty || password.trim().isEmpty) {
      emit(SettingsUpdatingError('Account name and password cannot be empty',
          popCount: 0));
      return;
    } else if (password.trim().length < 6) {
      emit(SettingsUpdatingError('Password must be at least 6 characters long',
          popCount: 0));
      return;
    } else {
      try {
        emit(SettingsLoading());
        UserModel newUserAccount = UserModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userName: accountName,
          password: password,
          role: UserType.user,
        );
        await _settingsRepo.addUserAccount(newUserAccount, newAuthData!);
        clinicUsers.insert(clinicUsers.length - 1, newUserAccount);
        emit(SettingsUpdated(
            authData: newAuthData!, message: 'Account added successfully'));
      } catch (e) {
        emit(SettingsUpdatingError('Failed to add account'));
      }
    }
  }

  void onAccountDeleted(String userId) async {
    try {
      emit(SettingsLoading());
      await _settingsRepo.deleteUserAccount(newAuthData!, userId);
      clinicUsers.removeWhere((element) => element.id == userId);
      emit(SettingsUpdated(
          message: 'Account deleted successfully',
          authData: newAuthData!,
          popCount: 0));
    } catch (e) {
      emit(SettingsUpdatingError('Failed to delete account'));
    }
  }

  bool checkAdminPassword(String adminPassword) {
    if (newAuthData!.userModel.password == adminPassword) {
      return true;
    }
    return false;
  }
}
