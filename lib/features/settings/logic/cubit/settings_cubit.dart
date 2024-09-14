import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
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
      emit(SettingsError(AppStrings.failedToGetUsers.tr()));
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

  void onSavePreferences(BuildContext context) async {
    try {
      emit(SettingsLoading());
      // Save preferences to firestore
      await _settingsRepo.updatePreferences(newAuthData!);
    } catch (e) {
      emit(SettingsUpdatingError(
        AppStrings.failedToUpdatePreferences.tr(),
      ));
      return;
    }
    authData = newAuthData;
    if (context.mounted) {
      _updateLocale(context, newAuthData!.language);
      await Future.delayed(const Duration(seconds: 1));
    }
    emit(SettingsUpdated(
        authData: newAuthData!,
        message: AppStrings.preferencesUpdatedSuccessfully.tr(),
        popCount: 0));
    saveButtonState.value = false;
  }

  void _updateLocale(BuildContext context, String language) {
    switch (language) {
      case 'English':
        context.setLocale(const Locale('en'));
        break;
      case 'العربية':
        context.setLocale(const Locale('ar'));
        break;
    }
  }

  void onChangePassword(String password, String newPassword) async {
    if (newPassword.trim().length < 6) {
      emit(SettingsUpdatingError(AppStrings.passwordLengthRequirement.tr(),
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
            message: AppStrings.passwordUpdatedSuccessfully.tr(),
          ));
        } catch (e) {
          emit(SettingsUpdatingError(AppStrings.failedToUpdatePassword.tr()));
        }
      } else {
        emit(SettingsUpdatingError(AppStrings.incorrectCurrentPassword.tr(),
            popCount: 0));
      }
    }
  }

  void onClinicNameChanged(String clinicName) {
    if (clinicName.trim() == newAuthData!.clinicName) return;
    if (clinicName.trim().isEmpty) {
      emit(SettingsUpdatingError(AppStrings.clinicNameCannotBeEmpty.tr(),
          popCount: 0));
      return;
    }
    try {
      emit(SettingsLoading());
      newAuthData = newAuthData!.copyWith(clinicName: clinicName);
      _settingsRepo.updatePreferences(newAuthData!);
      emit(SettingsUpdated(
          authData: newAuthData!,
          message: AppStrings.clinicNameUpdatedSuccessfully.tr()));
    } catch (e) {
      emit(SettingsUpdatingError(AppStrings.failedToUpdateClinicName.tr()));
    }
  }

  void onAccountAdded(String accountName, String password) async {
    if (accountName.trim().isEmpty || password.trim().isEmpty) {
      emit(SettingsUpdatingError(
          AppStrings.accountNameAndPasswordCannotBeEmpty.tr(),
          popCount: 0));
      return;
    } else if (password.trim().length < 6) {
      emit(SettingsUpdatingError(AppStrings.passwordLengthRequirement.tr()));
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
            authData: newAuthData!,
            message: AppStrings.accountAddedSuccessfully.tr()));
      } catch (e) {
        emit(SettingsUpdatingError(AppStrings.failedToAddAccount.tr()));
      }
    }
  }

  void onAccountDeleted(String userId) async {
    try {
      emit(SettingsLoading());
      await _settingsRepo.deleteUserAccount(newAuthData!, userId);
      clinicUsers.removeWhere((element) => element.id == userId);
      emit(SettingsUpdated(
          message: AppStrings.accountDeletedSuccessfully.tr(),
          authData: newAuthData!,
          popCount: 0));
    } catch (e) {
      emit(SettingsUpdatingError(AppStrings.failedToDeleteAccount.tr()));
    }
  }

  bool checkAdminPassword(String adminPassword) {
    if (newAuthData!.userModel.password == adminPassword) {
      return true;
    }
    return false;
  }
}
