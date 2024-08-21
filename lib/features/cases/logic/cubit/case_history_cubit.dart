import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/cases/data/local/repos/case_history_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'case_history_state.dart';

class CaseHistoryCubit extends Cubit<CaseHistoryState> {
  final CaseHistoryRepo _caseHistoryRepo;
  CaseHistoryCubit(this._caseHistoryRepo) : super(CaseHistoryInitial());

  AuthDataModel? authData;
  TextEditingController caseIdController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController petTypeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController petReportController = TextEditingController();

  List<CaseHistoryModel?> casesList = [];
  List<CaseHistoryModel?> searchResult = [];
  List<bool> selectedRows = [];

  int pageLength = 10;

  ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);

  void setupSectionData(AuthDataModel authenticationData) {
    _setAuthData(authenticationData);
    _getPaginatedCases();
  }

  void _setAuthData(AuthDataModel authenticationData) {
    authData = authenticationData;
  }

  void _getPaginatedCases() async {
    emit(CaseHistoryLoading());
    try {
      final List<CaseHistoryModel> newCasesList =
          await _caseHistoryRepo.getAllCases(authData!.clinicIndex, null);
      casesList.addAll(newCasesList);
      selectedRows = List.filled(casesList.length, false);
      emit(CaseHistorySuccess(cases: casesList));
    } catch (e) {
      emit(CaseHistoryError('Failed to get the cases'));
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
        emit(CaseHistorySuccess(cases: casesList));
      } catch (e) {
        emit(CaseHistoryError('Failed to get the cases'));
      }
    }
  }

  Future<String?> getFirstCaseId() async {
    return await _caseHistoryRepo.getFirstCaseId(authData!.clinicIndex, false);
  }

  Future<String?> getLastCaseId() async {
    return await _caseHistoryRepo.getFirstCaseId(authData!.clinicIndex, true);
  }

  Future<void> refreshCases() async {
    emit(CaseHistoryLoading());
    try {
      casesList =
          await _caseHistoryRepo.getAllCases(authData!.clinicIndex, null);
    } catch (e) {
      emit(CaseHistoryError('Failed to get the cases'));
    }
    emit(CaseHistorySuccess(cases: casesList));
  }

  void setupNewModeControllers() {
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
    ownerNameController.text = caseHistory.ownerName;
    petNameController.text = caseHistory.petName ?? '';
    petTypeController.text = caseHistory.petType ?? '';
    phoneController.text = caseHistory.phone ?? '';
    timeController.text = caseHistory.time ?? '';
    dateController.text = caseHistory.date;
    petReportController.text = _gethandledReportText(caseHistory.petReport);
  }

  void validateAndSaveCase() async {
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
        _onSuccessOperation();
      } else {
        emit(NewCaseHistoryFailure('Failed to add the appointment'));
      }
    } else {
      emit(NewCaseHistoryInvalid(
        title: 'Empty Fields',
        _getEmptyFieldsMessage(emptyFields),
      ));
    }
  }

  CaseHistoryModel getCaseHistoryById(String caseId) {
    try {
      if (searchResult.isEmpty) {
        return casesList.firstWhere((element) => element!.id == caseId)
            as CaseHistoryModel;
      } else {
        return searchResult.firstWhere((element) => element!.id == caseId)
            as CaseHistoryModel;
      }
    } catch (e) {
      emit(CaseHistoryError('Failed to get the case'));
      rethrow;
    }
  }

  void validateAndUpdateCase() async {
    final List<String> emptyFields = _getEmptyOfRequiredFields();
    if (emptyFields.isEmpty) {
      emit(NewCaseHistoryLoading());
      final CaseHistoryModel updatedCase = _constructCaseModel(update: true);
      final bool success =
          await _caseHistoryRepo.updateCase(updatedCase, authData!.clinicIndex);
      if (success) {
        emit(UpdateCaseHistorySuccess());
        refreshCases();
      } else {
        emit(NewCaseHistoryFailure('Failed to update the case'));
      }
    } else {
      emit(NewCaseHistoryInvalid(
        title: 'Empty Fields',
        _getEmptyFieldsMessage(emptyFields),
      ));
    }
  }

  void deleteCase(String caseId) async {
    emit(CaseHistoryLoading());
    final bool success =
        await _caseHistoryRepo.deleteCase(caseId, authData!.clinicIndex);
    if (success) {
      _onSuccessOperation();
      _resetShowDeleteButtonNotifier();
    } else {
      emit(CaseHistoryError('Failed to delete the case'));
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
    emit(CaseHistoryLoading());
    try {
      for (int i = 0; i < selectedRows.length; i++) {
        if (selectedRows.elementAt(i)) {
          final caseId = casesList.elementAt(i)!.id;
          await _caseHistoryRepo.deleteCase(caseId, authData!.clinicIndex);
        }
      }
      _resetShowDeleteButtonNotifier();
      emit(DeleteCaseHistorySuccess());
      _onSuccessOperation();
    } catch (e) {
      emit(CaseHistoryError('Failed to delete these cases'));
    }
  }

  void _onSuccessOperation() async {
    await refreshCases();
    selectedRows = List.filled(casesList.length, false);
    emit(CaseHistorySuccess(cases: casesList));
  }

  String _getEmptyFieldsMessage(List<String> emptyFields) {
    String errorMessage = 'Please fill the following fields: ';
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
      emptyFields.add('Owner name');
    }
    if (dateController.text.trim().isEmpty) {
      emptyFields.add('Date');
    }
    if (petReportController.text.trim().isEmpty) {
      emptyFields.add('Pet report');
    }
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
    emit(CaseHistoryLoading());
    value = value.toLowerCase();

    // Search cases by owner name
    searchResult = await _caseHistoryRepo.searchCases(
        authData!.clinicIndex, value, 'ownerName');

    if (value.isEmpty || searchResult.isEmpty) {
      emit(CaseHistorySuccess(cases: casesList));
      return;
    }

    emit(CaseHistorySuccess(cases: searchResult));
  }
}
