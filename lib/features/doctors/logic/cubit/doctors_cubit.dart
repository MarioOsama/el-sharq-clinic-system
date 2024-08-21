import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/features/doctors/data/models/doctor_model.dart';
import 'package:flutter/material.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit() : super(DoctorsInitial());

  // Variables
  GlobalKey<FormState> doctorFormKey = GlobalKey<FormState>();
  ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);
  List<DoctorModel> doctorsList = [];
  List<DoctorModel> searchResult = [];
  List<bool> selectedRows = [];
  DoctorModel doctor = DoctorModel(
    id: 'DCR000',
    name: '',
    phoneNumber: '',
    speciality: '',
    anotherPhoneNumber: '',
    email: '',
    address: '',
  );

  // UI methods
  void setupNewSheet() {
    doctorFormKey = GlobalKey<FormState>();
  }

  void setupExistingSheet(DoctorModel doctor) {
    doctorFormKey = GlobalKey<FormState>();
    this.doctor = doctor;
  }
}
