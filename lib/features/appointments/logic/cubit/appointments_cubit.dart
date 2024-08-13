import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit() : super(AppointmentsInitial());

  String appointmentId = '';
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController petNameController = TextEditingController();
  TextEditingController petTypeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController petConditionController = TextEditingController();

  void clearAllControllers() {
    ownerNameController.clear();
    petNameController.clear();
    petTypeController.clear();
    phoneController.clear();
    timeController.clear();
    dateController.clear();
    petConditionController.clear();
  }

  void validateAndSave() {
    final List<String> emptyFields = _getEmptyFields();

    if (emptyFields.isEmpty) {
      log('Saving appointment');
    } else {
      log('Error: ${_getErrorMessage(emptyFields)}');
      emit(AppointmentsError(
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

  List<String> _getEmptyFields() {
    List<String> emptyFields = [];
    if (ownerNameController.text.trim().isEmpty) {
      emptyFields.add('Owner name');
    }
    if (petNameController.text.trim().isEmpty) {
      emptyFields.add('Pet name');
    }
    if (phoneController.text.trim().isEmpty) {
      emptyFields.add('Phone number');
    }
    if (timeController.text.trim().isEmpty) {
      emptyFields.add('Time');
    }
    if (dateController.text.trim().isEmpty) {
      emptyFields.add('Date');
    }
    return emptyFields;
  }
}
