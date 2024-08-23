import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:flutter/material.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesInitial());

  // Variables
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController servicePriceController = TextEditingController();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController serviceIconController = TextEditingController();
  String serviceIconPath = '';
  List<ServiceModel> servicesList = [];

  // UI Logic
  void setupNewSheet() {
    serviceNameController.clear();
    servicePriceController.clear();
    serviceDescriptionController.clear();
    serviceIconPath = Assets.assetsImagesPngHeartRate;
  }

  void setupExistingSheet(ServiceModel service) {
    serviceNameController.text = service.title;
    servicePriceController.text = '${service.price} LE';
    serviceDescriptionController.text = service.description ?? '';
    serviceIconPath = service.icon;
  }

  void onIconChanged(String? value) {
    serviceIconPath = value ?? '';
  }
}
