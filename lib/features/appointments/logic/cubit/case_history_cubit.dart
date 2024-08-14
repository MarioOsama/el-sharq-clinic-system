import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/appointments/data/local/models/appointment_model.dart';
import 'package:el_sharq_clinic/features/appointments/data/local/repos/case_history_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'case_history_state.dart';

class CaseHistoryCubit extends Cubit<CaseHistoryState> {
  final CaseHistoryRepo _caseHistoryRepo;
  CaseHistoryCubit(this._caseHistoryRepo) : super(CaseHistoryInitial());

  AuthDataModel? authData;
  String appointmentId = '';
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController petTypeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController petReportController = TextEditingController();

  void setAuthData(AuthDataModel authenticationData) {
    authData = authenticationData;
  }

  void setupControllers() {
    ownerNameController.clear();
    petNameController.clear();
    petTypeController.clear();
    phoneController.clear();
    timeController.clear();
    dateController.clear();
    petReportController.text = _getPetReportScheme;
  }

  void validateAndSaveCase() async {
    final List<String> emptyFields = _getEmptyOfRequiredFields();
    if (emptyFields.isEmpty) {
      emit(NewCaseHistoryLoading());
      final CaseHistoryModel appointment = _constructAppointment();
      final bool successAddition =
          await _caseHistoryRepo.addNewCase(appointment, authData!.clinicIndex);
      if (successAddition) {
        emit(NewCaseHistorySuccess());
      } else {
        emit(NewCaseHistoryFailure('Failed to add the appointment'));
      }
    } else {
      emit(NewCaseHistoryInvalid(
        title: 'Empty Fields',
        _getErrorMessage(emptyFields),
      ));
    }
  }

  String _getErrorMessage(List<String> emptyFields) {
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
      emptyFields.add('Pet condition');
    }
    return emptyFields;
  }

  CaseHistoryModel _constructAppointment() {
    return CaseHistoryModel(
      id: appointmentId,
      ownerName: ownerNameController.text.trim(),
      petName: petNameController.text.trim(),
      petType: petTypeController.text.trim(),
      phone: phoneController.text.trim(),
      time: timeController.text.trim(),
      date: DateTime.parse(dateController.text.trim()),
      petCondition: petReportController.text.trim(),
    );
  }

  String get _getPetReportScheme {
    return """Diagnosis:
Temp:
Unique signs : 
R.R :
H.R :
B.W : ..... kg 
Vaccinations : 
Treatment :""";
  }
}
