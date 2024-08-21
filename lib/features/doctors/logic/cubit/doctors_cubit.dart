import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
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
      emit(DoctorsError('Failed to get the doctors'));
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
        emit(DoctorsError('Failed to get the doctors'));
      }
    }
  }

  Future<String?> getFirstDoctorId() async {
    return await _doctorsRepo.getFirstDoctorId(authData!.clinicIndex, false);
  }

  // Save doctor methods
  void onSaveDoctor() async {
    if (doctorFormKey.currentState!.validate()) {
      emit(DoctorLoading());
      doctorFormKey.currentState!.save();
      await _setDoctorId();
      final bool saveSuccess = await _doctorsRepo.addDoctor(
          doctorInfo, doctorInfo.id, authData!.clinicIndex);
      if (saveSuccess) {
        emit(DoctorSaved());
        _onSuccessOperation();
      } else {
        emit(DoctorsError('Failed to save the doctor'));
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
          DoctorsError('Failed to update doctor info'),
        );
      }
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
      for (int i = 0; i < selectedRows.length; i++) {
        if (selectedRows.elementAt(i)) {
          final doctorId = doctorsList.elementAt(i)!.id;
          await _deleteDoctor(doctorId);
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
      _resetShowDeleteButtonNotifier();
      _onSuccessOperation();
    } else {
      emit(DoctorsError('Failed to delete the doctor'));
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
    emit(DoctorsLoading());
    await refreshDoctors();
    selectedRows = List.filled(doctorsList.length, false);
    emit(DoctorsSuccess(doctors: doctorsList));
  }

  Future<void> refreshDoctors() async {
    try {
      doctorsList = await _doctorsRepo.getDoctors(authData!.clinicIndex, null);
    } catch (e) {
      emit(DoctorsError('Failed to get the doctors'));
    }
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
      name: field == 'Doctor Name' ? value : doctorInfo.name,
      speciality: field == 'Speciality' ? value : doctorInfo.speciality,
      email: field == 'Email' ? value : doctorInfo.email,
      address: field == 'Address' ? value : doctorInfo.address,
      phone: field == 'Phone Number' ? value : doctorInfo.phone,
      anotherPhone:
          field == 'Another Phone Number' ? value : doctorInfo.anotherPhone,
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
      emit(DoctorsError('Failed to get the doctor'));
      rethrow;
    }
  }
}
