import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
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
  List<bool> selectedRows = [false];
  DoctorModel doctor = DoctorModel(
    id: 'DCR000',
    name: '',
    phoneNumber: '',
    speciality: '',
    anotherPhoneNumber: '',
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
      emit(DoctorsError('Failed to get the owners'));
    }
  }

  void getNextPage(int firstIndex) async {
    String? lastOwnerId = doctorsList.lastOrNull?.id;
    final String? lastOwnerIdInFirestore = await getFirstDoctorId();
    final bool isLastPage = doctorsList.length - firstIndex <= pageLength;
    if (lastOwnerIdInFirestore.toString() != lastOwnerId.toString() &&
        isLastPage) {
      try {
        final List<DoctorModel> newOwnersList =
            await _doctorsRepo.getDoctors(authData!.clinicIndex, lastOwnerId);
        doctorsList.addAll(newOwnersList);
        selectedRows = List.filled(doctorsList.length, false);
        emit(DoctorsSuccess(doctors: doctorsList));
      } catch (e) {
        emit(DoctorsError('Failed to get the owners'));
      }
    }
  }

  Future<String?> getFirstDoctorId() async {
    return await _doctorsRepo.getLastOwnerId(authData!.clinicIndex, false);
  }

  // Delete doctor methods
  void onDeleteSelectedDoctors() async {
    emit(DoctorsLoading());
    try {
      for (int i = 0; i < selectedRows.length; i++) {
        if (selectedRows.elementAt(i)) {
          final ownerId = doctorsList.elementAt(i)!.id;
          await _deleteDoctor(ownerId);
        }
      }
      _resetShowDeleteButtonNotifier();
      emit(DoctorDeleted());
      _onSuccessOperation();
    } catch (e) {
      emit(DoctorsError('Failed to delete these selected cases'));
    }
  }

  void onDeleteDoctor(String doctorId) async {
    emit(DoctorsLoading());
    final bool deletionSuccess = await _deleteDoctor(doctorId);
    if (deletionSuccess) {
      emit(DoctorDeleted());
      _onSuccessOperation();
    } else {
      emit(DoctorsError('Failed to delete the owner'));
    }
  }

  Future<bool> _deleteDoctor(String id) async {
    final bool ownerDeletionSuccess =
        await _doctorsRepo.deleteDoctor(authData!.clinicIndex, id);
    if (!ownerDeletionSuccess) {
      return false;
    }
    return true;
  }

  void _onSuccessOperation() async {
    emit(DoctorsLoading());
    await refreshDoctors();
    selectedRows = List.filled(doctorsList.length, false);
    emit(DoctorsSuccess(doctors: doctorsList));
  }

  Future<void> refreshDoctors() async {
    try {
      doctorsList = await _doctorsRepo.getDoctors(authData!.clinicIndex, null);
    } catch (e) {
      emit(DoctorsError('Failed to get the owners'));
    }
  }

  // UI methods
  void setupNewSheet() {
    doctorFormKey = GlobalKey<FormState>();
  }

  void setupExistingSheet(DoctorModel doctor) {
    doctorFormKey = GlobalKey<FormState>();
    this.doctor = doctor;
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

  DoctorModel getDoctorById(String ownerId) {
    try {
      if (searchResult.isEmpty) {
        return doctorsList.firstWhere((element) => element!.id == ownerId)
            as DoctorModel;
      } else {
        return searchResult.firstWhere((element) => element!.id == ownerId)
            as DoctorModel;
      }
    } catch (e) {
      emit(DoctorsError('Failed to get the owner'));
      rethrow;
    }
  }
}
