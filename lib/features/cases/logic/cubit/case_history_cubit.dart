import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/cases/data/local/repos/case_history_repo.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'case_history_state.dart';

class CaseHistoryCubit extends Cubit<CaseHistoryState> {
  final CaseHistoryRepo _caseHistoryRepo;
  CaseHistoryCubit(this._caseHistoryRepo) : super(CasesInitial());

  AuthDataModel? authData;
  TextEditingController caseIdController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController petTypeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController petReportController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();

  List<CaseHistoryModel?> casesList = [];
  List<CaseHistoryModel?> searchResult = [];
  List<bool> selectedRows = [];
  List<DoctorModel> doctorsList = [];

  String doctorId = '';
  int pageLength = 10;

  ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);

  void setupSectionData(AuthDataModel authenticationData) {
    _setAuthData(authenticationData);
    _getPaginatedCases();
    _getDoctors();
  }

  void _setAuthData(AuthDataModel authenticationData) {
    authData = authenticationData;
  }

  void _getPaginatedCases() async {
    emit(CasesLoading());
    try {
      final List<CaseHistoryModel> newCasesList =
          await _caseHistoryRepo.getAllCases(authData!.clinicIndex, null);
      casesList.addAll(newCasesList);
      selectedRows = List.filled(casesList.length, false);
      emit(CasesSuccess(cases: casesList));
    } catch (e) {
      emit(CasesError(AppStrings.failedCases.tr()));
    }
  }

  void getNextPage(int firstIndex) async {
    String? lastCaseId = casesList.lastOrNull?.id;
    final String? lastCaseIdInFirestore = await getFirstCaseId();
    final bool isLastPage = casesList.length - firstIndex <= pageLength;
    if (lastCaseIdInFirestore.toString() != lastCaseId.toString() &&
        isLastPage) {
      try {
        final List<CaseHistoryModel> newCasesList = await _caseHistoryRepo
            .getAllCases(authData!.clinicIndex, lastCaseId);
        casesList.addAll(newCasesList);

        selectedRows = List.filled(casesList.length, false);
        emit(CasesSuccess(cases: casesList));
      } catch (e) {
        emit(CasesError(AppStrings.failedCases.tr()));
      }
    }
  }

  Future<String?> getFirstCaseId() async {
    return await _caseHistoryRepo.getFirstCaseId(authData!.clinicIndex, false);
  }

  Future<String?> getLastCaseId() async {
    return await _caseHistoryRepo.getFirstCaseId(authData!.clinicIndex, true);
  }

  void setupNewModeControllers() {
    doctorId = '';
    doctorNameController.clear();
    caseIdController.clear();
    ownerNameController.clear();
    petNameController.clear();
    petTypeController.clear();
    phoneController.clear();
    timeController.clear();
    dateController.clear();
    petReportController.text = _getPetReportScheme;
  }

  void setupShowModeControllers(CaseHistoryModel caseHistory) {
    caseIdController.text = caseHistory.id;
    doctorNameController.text = caseHistory.doctorId ?? '';
    ownerNameController.text = caseHistory.ownerName;
    petNameController.text = caseHistory.petName ?? '';
    petTypeController.text = caseHistory.petType ?? '';
    phoneController.text = caseHistory.phone ?? '';
    timeController.text = caseHistory.time ?? '';
    dateController.text = caseHistory.date;
    petReportController.text = _gethandledReportText(caseHistory.petReport);
  }

  void validateAndSaveCase() async {
    if (!_validatePhoneIfExist()) {
      return;
    }
    final List<String> emptyFields = _getEmptyOfRequiredFields();
    // Check that there are no empty required fields
    if (emptyFields.isEmpty) {
      // Save new case
      emit(NewCaseHistoryLoading());
      final String? lastCaseIdInFirestore = await getLastCaseId();

      final CaseHistoryModel newCase = _constructCaseModel(
          lastCaseIdInFirestore: lastCaseIdInFirestore, update: false);
      final bool successAddition =
          await _caseHistoryRepo.addNewCase(newCase, authData!.clinicIndex);
      if (successAddition) {
        emit(NewCaseHistorySuccess());
        casesList.insert(0, newCase);
        _onSuccessOperation();
      } else {
        emit(NewCaseHistoryFailure(AppStrings.failedSavingCase.tr()));
      }
    } else {
      emit(NewCaseHistoryInvalid(
        title: AppStrings.emptyfield.tr(),
        _getEmptyFieldsMessage(emptyFields),
      ));
    }
  }

  bool _validatePhoneIfExist() {
    if (phoneController.text.trim().isNotEmpty) {
      if (phoneController.text.trim().length < 10 ||
          phoneController.text.trim().length > 15 ||
          !phoneController.text.trim().isPhoneNumber()) {
        emit(NewCaseHistoryInvalid(
          AppStrings.phoneNumberError.tr(),
        ));
        return false;
      }
      return true;
    }
    return true;
  }

  CaseHistoryModel getCaseHistoryById(String caseId) {
    try {
      return searchResult.firstWhere((element) => element!.id == caseId)
          as CaseHistoryModel;
    } catch (e) {
      return casesList.firstWhere((element) => element!.id == caseId)
          as CaseHistoryModel;
    }
  }

  void validateAndUpdateCase() async {
    if (!_validatePhoneIfExist()) {
      return;
    }
    final List<String> emptyFields = _getEmptyOfRequiredFields();
    if (emptyFields.isEmpty) {
      emit(NewCaseHistoryLoading());
      final CaseHistoryModel updatedCase = _constructCaseModel(update: true);
      final bool success =
          await _caseHistoryRepo.updateCase(updatedCase, authData!.clinicIndex);
      if (success) {
        emit(UpdateCaseHistorySuccess());
        final int index =
            casesList.indexWhere((element) => element!.id == updatedCase.id);
        casesList[index] = updatedCase;
        _onSuccessOperation();
      } else {
        emit(NewCaseHistoryFailure(AppStrings.failedUpdatingCase.tr()));
      }
    } else {
      emit(NewCaseHistoryInvalid(
        title: AppStrings.emptyfield.tr(),
        _getEmptyFieldsMessage(emptyFields),
      ));
    }
  }

  void deleteCase(String caseId) async {
    emit(CasesLoading());
    final bool success =
        await _caseHistoryRepo.deleteCase(caseId, authData!.clinicIndex);
    if (success) {
      emit(DeleteCaseHistorySuccess());
      casesList.removeWhere((element) => element!.id == caseId);
      _onSuccessOperation();
      _resetShowDeleteButtonNotifier();
    } else {
      emit(CasesError(AppStrings.failedDeletingCase.tr()));
    }
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
      showDeleteButtonNotifier.value = false;
    }
  }

  void deleteSelectedCases() async {
    emit(CasesLoading());
    try {
      final List<String> deletedCasesIds = [];
      // Get all the selected cases
      for (int i = 0; i < selectedRows.length; i++) {
        if (selectedRows.elementAt(i)) {
          deletedCasesIds.add(casesList.elementAt(i)!.id);
        }
      }
      // Delete all the selected cases
      for (String caseId in deletedCasesIds) {
        await _caseHistoryRepo.deleteCase(caseId, authData!.clinicIndex);
        casesList.removeWhere((element) => element!.id == caseId);
      }
      _resetShowDeleteButtonNotifier();
      emit(DeleteCaseHistorySuccess());
      _onSuccessOperation();
    } catch (e) {
      emit(CasesError(AppStrings.failedDeletingCase.tr()));
    }
  }

  // Doctors
  Future<void> _getDoctors() async {
    try {
      doctorsList = await _caseHistoryRepo.getAllDoctors(authData!.clinicIndex);
    } catch (e) {
      emit(CasesError(AppStrings.failedDoctors.tr()));
    }
  }

  void onSelectDoctor(String? value) {
    if (value == null) {
      doctorId = '';
      doctorNameController.clear();
      emit(NewCaseHistoryInvalid(AppStrings.doctorDoesNotExist.tr()));
      return;
    }
    doctorId = value;
  }

  void _onSuccessOperation() async {
    selectedRows = List.filled(casesList.length, false);
    emit(CasesSuccess(cases: casesList));
  }

  String _getEmptyFieldsMessage(List<String> emptyFields) {
    String errorMessage = AppStrings.fillRequiredFields.tr();
    for (int i = 0; i < emptyFields.length; i++) {
      errorMessage += emptyFields[i];
      if (i != emptyFields.length - 1) {
        errorMessage += ', ';
      }
    }
    return errorMessage;
  }

  List<String> _getEmptyOfRequiredFields() {
    List<String> emptyFields = [];
    if (ownerNameController.text.trim().isEmpty) {
      emptyFields.add(AppStrings.ownerName.tr());
    }
    if (dateController.text.trim().isEmpty) {
      emptyFields.add(AppStrings.date.tr());
    }
    if (petReportController.text.trim().isEmpty) {
      emptyFields.add(AppStrings.petReport.tr());
    }
    // if (doctorId.trim().isEmpty ||
    //     doctorNameController.text.trim().isEmpty ||
    //     doctorsList.every(
    //         (doctor) => doctor.name != doctorNameController.text.trim())) {
    //   emptyFields.add('Doctor');
    // }
    return emptyFields;
  }

  CaseHistoryModel _constructCaseModel(
      {String? lastCaseIdInFirestore, required bool update}) {
    if (!update) {
      if (lastCaseIdInFirestore != null) {
        lastCaseIdInFirestore = lastCaseIdInFirestore.getNextId(3, 'CSE');
      } else {
        lastCaseIdInFirestore = 'CSE000';
      }
    }
    return CaseHistoryModel(
      id: update ? caseIdController.text.trim() : lastCaseIdInFirestore!,
      doctorId: doctorId,
      ownerName: ownerNameController.text.trim().toLowerCase(),
      petName: petNameController.text.trim(),
      petType: petTypeController.text.trim(),
      phone: phoneController.text.trim(),
      time: timeController.text.trim(),
      date: dateController.text.trim(),
      petReport: _getReportFirebaseText,
    );
  }

  String get _getPetReportScheme {
    return AppConstant.petCaseReportScheme;
  }

  String get _getReportFirebaseText {
    final handledText = petReportController.text
        .trim()
        .split('\n')
        .map((element) {
          return '$element---n';
        })
        .toList()
        .join();
    return handledText;
  }

  String _gethandledReportText(String petReport) {
    return petReport.replaceAll('---n', '\n');
  }

  void _resetShowDeleteButtonNotifier() {
    showDeleteButtonNotifier.value = false;
  }

  void onSearch(String value) async {
    // Emit loading state to show loading indicator & refresh cases
    emit(CasesLoading());
    value = value.toLowerCase();

    // Search cases by owner name
    searchResult = await _caseHistoryRepo.searchCases(
        authData!.clinicIndex, value, 'ownerName');

    if (value.isEmpty || searchResult.isEmpty) {
      emit(CasesSuccess(cases: casesList));
      return;
    }

    emit(CasesSuccess(cases: searchResult));
  }
}
