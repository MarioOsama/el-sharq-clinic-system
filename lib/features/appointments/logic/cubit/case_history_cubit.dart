import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/appointments/data/local/models/case_history_model.dart';
import 'package:el_sharq_clinic/features/appointments/data/local/repos/case_history_repo.dart';
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

  ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);
  List<int> selectedItems = [];

  void setAuthData(AuthDataModel authenticationData) {
    authData = authenticationData;
  }

  void getAllCases() async {
    emit(CaseHistoryLoading());
    final List<CaseHistoryModel> cases =
        await _caseHistoryRepo.getAllCases(authData!.clinicIndex);
    emit(CaseHistorySuccess(cases: cases));
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
    caseIdController.text = caseHistory.id!;
    ownerNameController.text = caseHistory.ownerName;
    petNameController.text = caseHistory.petName;
    petTypeController.text = caseHistory.petType;
    phoneController.text = caseHistory.phone;
    timeController.text = caseHistory.time;
    dateController.text = caseHistory.date;
    petReportController.text = _gethandledReportText(caseHistory.petReport);
  }

  void validateAndSaveCase() async {
    final List<String> emptyFields = _getEmptyOfRequiredFields();
    if (emptyFields.isEmpty) {
      emit(NewCaseHistoryLoading());
      final CaseHistoryModel newCase = _constructNewCase(update: false);
      final bool successAddition =
          await _caseHistoryRepo.addNewCase(newCase, authData!.clinicIndex);
      if (successAddition) {
        emit(NewCaseHistorySuccess());
        getAllCases();
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

  CaseHistoryModel _constructNewCase({required bool update}) {
    if (update) {
      return CaseHistoryModel(
        id: caseIdController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        petName: petNameController.text.trim(),
        petType: petTypeController.text.trim(),
        phone: phoneController.text.trim(),
        time: timeController.text.trim(),
        date: dateController.text.trim(),
        petReport: _getReportFirebaseText,
      );
    }
    return CaseHistoryModel(
      ownerName: ownerNameController.text.trim(),
      petName: petNameController.text.trim(),
      petType: petTypeController.text.trim(),
      phone: phoneController.text.trim(),
      time: timeController.text.trim(),
      date: dateController.text.trim(),
      petReport: _getReportFirebaseText,
    );
  }

  String get _getPetReportScheme {
    return """Diagnosis:
Temp:
Unique signs: 
R.R:
H.R:
B.W: ..... kg 
Vaccinations:
Treatment:""";
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

  CaseHistoryModel? getCaseHistoryById(String id) {
    try {
      return (state as CaseHistorySuccess)
          .cases
          .firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  void validateAndUpdateCase() async {
    final List<String> emptyFields = _getEmptyOfRequiredFields();
    if (emptyFields.isEmpty) {
      emit(NewCaseHistoryLoading());
      final CaseHistoryModel updatedCase = _constructNewCase(update: true);
      final bool success =
          await _caseHistoryRepo.updateCase(updatedCase, authData!.clinicIndex);
      if (success) {
        emit(UpdateCaseHistorySuccess());
        getAllCases();
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
      getAllCases();
    } else {
      emit(CaseHistoryError('Failed to delete the case'));
    }
  }

  void onMultiSelection(List<bool> selectedItemsList) {
    if (selectedItemsList.contains(true)) {
      for (int i = 0; i < selectedItemsList.length; i++) {
        if (selectedItemsList[i]) {
          if (!selectedItems.contains(i)) {
            selectedItems.add(i);
          }
        } else {
          selectedItems.remove(i);
        }
      }
      showDeleteButtonNotifier.value = true;
    } else {
      showDeleteButtonNotifier.value = false;
    }
  }

  void deleteSelectedCases() {
    final cases = (state as CaseHistorySuccess).cases;
    emit(CaseHistoryLoading());
    try {
      for (int i = 0; i < selectedItems.length; i++) {
        final caseId = cases[selectedItems[i]].id;
        _caseHistoryRepo.deleteCase(caseId!, authData!.clinicIndex);
      }
    } catch (e) {
      emit(CaseHistoryError('Failed to delete these cases'));
    }
    getAllCases();
  }
}
