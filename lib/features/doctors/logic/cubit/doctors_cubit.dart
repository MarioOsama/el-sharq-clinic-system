import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';
import 'package:el_sharq_clinic/features/doctors/data/repos/doctors_repo.dart';
import 'package:flutter/material.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorsRepo _doctorsRepo;
  DoctorsCubit(this._doctorsRepo) : super(DoctorsInitial());

  // Variables
  AuthDataModel? authData;
  GlobalKey<FormState> doctorFormKey = GlobalKey<FormState>();
  ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);
  int pageLength = 10;
  List<DoctorModel?> doctorsList = [];
  List<DoctorModel?> searchResult = [];
  List<bool> selectedRows = [];
  DoctorModel doctorInfo = DoctorModel(
    id: 'DCR000',
    name: '',
    phone: '',
    speciality: '',
    anotherPhone: '',
    email: '',
    address: '',
  );

  // Get doctors info methods
  void setupSectionData(AuthDataModel authenticationData) {
    authData = authenticationData;
    _getPaginatedDoctors();
  }

  void _getPaginatedDoctors() async {
    emit(DoctorsLoading());
    try {
      final List<DoctorModel> newDoctorsList = await _doctorsRepo.getDoctors(
        authData!.clinicIndex,
        null,
      );

      doctorsList.addAll(newDoctorsList);
      selectedRows = List.filled(doctorsList.length, false);
      emit(DoctorsSuccess(doctors: doctorsList));
    } catch (e) {
      emit(DoctorsError(AppStrings.failedDoctors.tr()));
    }
  }

  void getNextPage(int firstIndex) async {
    String? lastDoctorId = doctorsList.lastOrNull?.id;
    final String? lastDoctorIdInFirestore = await getFirstDoctorId();
    final bool isLastPage = doctorsList.length - firstIndex <= pageLength;
    if (lastDoctorIdInFirestore.toString() != lastDoctorId.toString() &&
        isLastPage) {
      try {
        final List<DoctorModel> newDoctorsList =
            await _doctorsRepo.getDoctors(authData!.clinicIndex, lastDoctorId);
        doctorsList.addAll(newDoctorsList);
        selectedRows = List.filled(doctorsList.length, false);
        emit(DoctorsSuccess(doctors: doctorsList));
      } catch (e) {
        emit(DoctorsError(AppStrings.failedDoctors.tr()));
      }
    }
  }

  Future<String?> getFirstDoctorId() async {
    return await _doctorsRepo.getFirstDoctorId(authData!.clinicIndex, false);
  }

  // Save doctor methods
  void onSaveDoctor() async {
    if (doctorFormKey.currentState!.validate()) {
      log(doctorInfo.toString());
      emit(DoctorLoading());
      doctorFormKey.currentState!.save();
      await _setDoctorId();
      final bool saveSuccess = await _doctorsRepo.addDoctor(
          doctorInfo, doctorInfo.id, authData!.clinicIndex);
      if (saveSuccess) {
        emit(DoctorSaved());
        doctorsList.insert(0, doctorInfo);
        _onSuccessOperation();
      } else {
        emit(DoctorError(AppStrings.failedToSaveDoctor.tr()));
      }
    }
  }

  Future<void> _setDoctorId() async {
    final String? lastCaseId = await getLastCaseId();

    if (lastCaseId != null) {
      doctorInfo = doctorInfo.copyWith(id: lastCaseId.getNextId(3, 'DCR'));
    } else {
      doctorInfo = doctorInfo.copyWith(id: 'DCR001');
    }
  }

  Future<String?> getLastCaseId() async {
    return await _doctorsRepo.getFirstDoctorId(authData!.clinicIndex, true);
  }

  // Update Doctor
  void onUpdateDoctor() async {
    if (doctorFormKey.currentState!.validate()) {
      emit(DoctorLoading());
      doctorFormKey.currentState!.save();
      // Update
      final bool doctorUpdatingSuccess = await _updateDoctor();
      if (!doctorUpdatingSuccess) {
        emit(
          DoctorError(AppStrings.failedToUpdateDoctor.tr()),
        );
      }
      final int index =
          doctorsList.indexWhere((element) => element!.id == doctorInfo.id);
      doctorsList[index] = doctorInfo;
      _onSuccessOperation();
      emit(DoctorUpdated());
    }
  }

  Future<bool> _updateDoctor() async {
    return await _doctorsRepo.updateDoctor(doctorInfo, authData!.clinicIndex);
  }

  // Delete doctor methods
  void onDeleteSelectedDoctors() async {
    emit(DoctorsLoading());
    try {
      final List<String> deletedDoctorsIds = [];
      // Get all the selected doctors
      for (int i = 0; i < selectedRows.length; i++) {
        if (selectedRows.elementAt(i)) {
          deletedDoctorsIds.add(doctorsList.elementAt(i)!.id);
        }
      }
      // Delete all the selected doctors
      for (String doctorId in deletedDoctorsIds) {
        await _doctorsRepo.deleteDoctor(authData!.clinicIndex, doctorId);
        doctorsList.removeWhere((element) => element!.id == doctorId);
      }
      _resetShowDeleteButtonNotifier();
      emit(DoctorDeleted());
      _onSuccessOperation();
    } catch (e) {
      emit(DoctorsError(AppStrings.failedToDeleteSelectedDoctors.tr()));
    }
  }

  void onDeleteDoctor(String doctorId) async {
    emit(DoctorsLoading());
    final bool deletionSuccess = await _deleteDoctor(doctorId);
    if (deletionSuccess) {
      emit(DoctorDeleted());
      doctorsList.removeWhere((element) => element!.id == doctorId);
      _resetShowDeleteButtonNotifier();
      _onSuccessOperation();
    } else {
      emit(DoctorsError(AppStrings.failedToDeleteDoctor.tr()));
    }
  }

  Future<bool> _deleteDoctor(String id) async {
    final bool doctorDeletionSuccess =
        await _doctorsRepo.deleteDoctor(authData!.clinicIndex, id);
    if (!doctorDeletionSuccess) {
      return false;
    }
    return true;
  }

  void _onSuccessOperation() async {
    selectedRows = List.filled(doctorsList.length, false);
    emit(DoctorsSuccess(doctors: doctorsList));
  }

  // Search doctor
  void onSearch(String value) async {
    // Emit loading state to show loading indicator & refresh owners
    emit(DoctorsLoading());
    // Search doctor by name
    searchResult =
        await _doctorsRepo.searchDoctors(authData!.clinicIndex, value, 'name');

    if (value.isEmpty || searchResult.isEmpty) {
      emit(DoctorsSuccess(doctors: doctorsList));
      return;
    }

    emit(DoctorsSuccess(doctors: searchResult));
  }

  // UI methods
  void setupNewSheet() {
    doctorFormKey = GlobalKey<FormState>();
    doctorInfo = DoctorModel(
      id: 'DCR000',
      name: '',
      phone: '',
      speciality: '',
      anotherPhone: '',
      email: '',
      address: '',
    );
  }

  void setupExistingSheet(DoctorModel doctor) {
    doctorFormKey = GlobalKey<FormState>();
    doctorInfo = doctor;
  }

  void onSaveDoctorFormField(String field, String? value) {
    doctorInfo = doctorInfo.copyWith(
      name: field == AppStrings.doctorName ? value : doctorInfo.name,
      speciality:
          field == AppStrings.speciality ? value : doctorInfo.speciality,
      email: field == AppStrings.email ? value : doctorInfo.email,
      address: field == AppStrings.address ? value : doctorInfo.address,
      phone: field == AppStrings.phone ? value : doctorInfo.phone,
      anotherPhone: field == AppStrings.anotherPhoneNumber
          ? value
          : doctorInfo.anotherPhone,
      registrationDate: doctorInfo.registrationDate,
    );
  }

  void onMultiSelection(int index, bool selected) {
    if (selectedRows.elementAt(index)) {
      selectedRows[index] = false;
    } else {
      selectedRows[index] = true;
    }

    if (selectedRows.any((element) => element)) {
      showDeleteButtonNotifier.value = true;
    } else {
      _resetShowDeleteButtonNotifier();
    }
  }

  void _resetShowDeleteButtonNotifier() {
    showDeleteButtonNotifier.value = false;
  }

  DoctorModel getDoctorById(String doctorId) {
    try {
      if (searchResult.isEmpty) {
        return doctorsList.firstWhere((element) => element!.id == doctorId)
            as DoctorModel;
      } else {
        return searchResult.firstWhere((element) => element!.id == doctorId)
            as DoctorModel;
      }
    } catch (e) {
      emit(DoctorsError(AppStrings.failedToGetDoctors.tr()));
      rethrow;
    }
  }
}
