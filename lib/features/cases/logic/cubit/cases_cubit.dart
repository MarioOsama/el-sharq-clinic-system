import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/logic/cubits_mixin.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/cases/data/local/repos/cases_repo.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cases_state.dart';

class CasesCubit extends Cubit<CasesState>
    with CubitsMixin<CaseHistoryModel, CasesState> {
  final CasesRepo _casesRepo;
  CasesCubit(this._casesRepo) : super(CasesInitial());

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

  List<DoctorModel> doctorsList = [];

  String doctorId = '';
  int pageLength = 10;

  void setupSectionData(AuthDataModel authenticationData) {
    _setAuthData(authenticationData);
    _getPaginatedCases();
    _getDoctors();
  }

  void _setAuthData(AuthDataModel authenticationData) {
    authData = authenticationData;
  }

  void _fetchPaginatedCases({String? lastCaseId}) async {
    await fetchPaginatedItems(
      successState: CasesSuccess(cases: itemsList),
      failureState: CasesError(AppStrings.failedCases.tr()),
      lastItemId: lastCaseId,
      fetchItems: () =>
          _casesRepo.getAllCases(authData!.clinicIndex, lastCaseId),
      onSuccess: (cases) {},
    );
  }

  void _getPaginatedCases() async {
    emit(CasesLoading());
    _fetchPaginatedCases();
  }

  void getNextPage(int firstIndex) async {
    String? lastCaseId = itemsList.lastOrNull?.id;
    final String? lastCaseIdInFirestore = await getFirstCaseId();
    final bool isLastPage = itemsList.length - firstIndex <= pageLength;
    final bool isLastCase =
        lastCaseIdInFirestore.toString() != lastCaseId.toString();
    if (isLastCase && isLastPage) {
      _fetchPaginatedCases(lastCaseId: lastCaseId);
    }
  }

  Future<String?> getFirstCaseId() async {
    return await _casesRepo.getFirstCaseId(authData!.clinicIndex, false);
  }

  Future<String?> getLastCaseId() async {
    return await _casesRepo.getFirstCaseId(authData!.clinicIndex, true);
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
    final String? lastCaseIdInFirestore = await getLastCaseId();
    final CaseHistoryModel newCase = _constructCaseModel(
        lastCaseIdInFirestore: lastCaseIdInFirestore, update: false);
    final List<String> emptyFields = _getEmptyOfRequiredFields();
    await validateAndSaveItem(
      loadingState: NewCaseLoading(),
      successSavingState: NewCaseSuccess(),
      successState: CasesSuccess(cases: itemsList),
      failureState: NewCaseFailure(AppStrings.failedCases.tr()),
      invalidState: _getInvalidState(emptyFields),
      newItem: newCase,
      addNewItem: () => _casesRepo.addNewCase(newCase, authData!.clinicIndex),
      validation: () => _validateCase(newCase, emptyFields),
    );
  }

  bool _validatePhoneIfExist() {
    final String phone = phoneController.text;
    if (phone.isNotEmpty &&
        (phone.length < 10 || phone.length > 15 || !phone.isPhoneNumber())) {
      return false;
    }
    return true;
  }

  CaseHistoryModel getCaseHistoryById(String caseId) {
    return getItemById(caseId);
  }

  void validateAndUpdateCase() async {
    final CaseHistoryModel updatedCase = _constructCaseModel(update: true);
    log(updatedCase.toString());
    final List<String> emptyFields = _getEmptyOfRequiredFields();
    await validateAndUpdateItem(
      loadingState: NewCaseLoading(),
      successUpdatingState: UpdateCaseSuccess(),
      successState: CasesSuccess(cases: itemsList),
      failureState: NewCaseFailure(AppStrings.failedUpdatingCase.tr()),
      invalidState: _getInvalidState(emptyFields),
      updatedItem: updatedCase,
      updateItem: () => _casesRepo.updateCase(
        updatedCase,
        authData!.clinicIndex,
      ),
      validation: () => _validateCase(updatedCase, emptyFields),
    );
  }

  bool _validateCase(CaseHistoryModel newCase, List<String> emptyFields) {
    if (!_validatePhoneIfExist()) {
      return false;
    }
    if (emptyFields.isNotEmpty) {
      return false;
    }
    return true;
  }

  NewCaseHistoryInvalid _getInvalidState(List<String> emptyFields) {
    if (emptyFields.isNotEmpty) {
      return NewCaseHistoryInvalid(
          title: AppStrings.emptyfield.tr(),
          _getEmptyFieldsMessage(emptyFields));
    }
    return NewCaseHistoryInvalid(
        title: AppStrings.error.tr(), _getEmptyFieldsMessage(emptyFields));
  }

  void deleteCase(String caseId) async {
    await deleteItem(
      loadingState: CasesLoading(),
      successDeletionState: DeleteCaseSuccess(),
      successState: CasesSuccess(cases: itemsList),
      failureState: CasesError(AppStrings.failedDeletingCase.tr()),
      itemId: caseId,
      deleteItem: () => _casesRepo.deleteCase(caseId, authData!.clinicIndex),
    );
  }

  void onMultiSelection(int index, bool selected) {
    onItemsMultiSelection(
        selectedRows, index, selected, showDeleteButtonNotifier);
  }

  void deleteSelectedCases() async {
    emit(CasesLoading());
    final List<String> deletedCasesIds = getSelectedItemsIds();
    await deleteItems(
      loadingState: CasesLoading(),
      successDeletionState: DeleteCaseSuccess(),
      successState: CasesSuccess(cases: itemsList),
      failureState: CasesError(AppStrings.failedDeletingCase.tr()),
      deleteItem: (caseId) =>
          _casesRepo.deleteCase(caseId, authData!.clinicIndex),
      itemsIds: deletedCasesIds,
    );
  }

  // Doctors
  Future<void> _getDoctors() async {
    try {
      doctorsList = await _casesRepo.getAllDoctors(authData!.clinicIndex);
    } catch (e) {
      _handleError((AppStrings.failedDoctors.tr()));
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

  void _handleError(String message) {
    emit(CasesError(message));
  }

  String _getEmptyFieldsMessage(List<String> emptyFields) {
    String errorMessage = '';
    if (emptyFields.isNotEmpty) {
      errorMessage += AppStrings.fillRequiredFields.tr();
      for (int i = 0; i < emptyFields.length; i++) {
        errorMessage += emptyFields[i];
        if (i != emptyFields.length - 1) {
          errorMessage += ', ';
        }
      }
    }
    if (!_validatePhoneIfExist()) {
      errorMessage += AppStrings.phoneNumberError.tr();
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

  void onSearch(String value) async {
    await searchForItems(
      performSearch: _performSearch(value),
      loadingState: CasesLoading(),
      successState: CasesSuccess(cases: itemsList),
      successSearchState: CasesSearching(cases: searchResult),
    );
  }

  Future<List<CaseHistoryModel>> _performSearch(String value) async {
    return await _casesRepo.searchCases(
        authData!.clinicIndex, value.toLowerCase(), 'ownerName');
  }
}
