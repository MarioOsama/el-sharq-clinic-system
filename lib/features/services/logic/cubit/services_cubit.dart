import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:el_sharq_clinic/features/services/data/repos/services_repo.dart';
import 'package:flutter/material.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepo _servicesRepo;

  ServicesCubit(this._servicesRepo) : super(ServicesInitial());

  // Variables
  AuthDataModel? _authData;
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController servicePriceController = TextEditingController();
  TextEditingController serviceDescriptionController = TextEditingController();
  TextEditingController serviceIconController = TextEditingController();
  String serviceIconPath = '';
  List<ServiceModel> servicesList = [];

  // Setup section data
  void setupSectionData(AuthDataModel authData) {
    _authData = authData;
    _getServices();
  }

  // Get services
  Future<void> _getServices() async {
    emit(ServicesLoading());
    servicesList =
        await _servicesRepo.getServices(_authData!.clinicIndex, null);
    emit(ServicesSuccess(services: servicesList));
  }

  // Save new service
  void validateThenSaveService() async {
    if (_validateService()) {
      emit(ServiceSaving());
      final ServiceModel service = _constructService;
      final bool result =
          await _servicesRepo.addService(_authData!.clinicIndex, service);

      if (result) {
        emit(ServiceAdded());
        servicesList.insert(0, service);
      } else {
        emit(ServiceError(
            'Failed to add the service, please ensure that the service name is unique'));
      }
    }
    emit(ServicesSuccess(services: servicesList));
  }

  bool _validateService() {
    bool valid = false;
    if (serviceNameController.text.isEmpty) {
      emit(ServiceError('Service name is required'));
    } else if (servicePriceController.text.isEmpty ||
        double.tryParse(servicePriceController.text) == null ||
        double.parse(servicePriceController.text) <= 0) {
      emit(ServiceError(
          'Service price is required, and must be a positive number'));
    } else {
      valid = true;
    }
    return valid;
  }

  ServiceModel get _constructService {
    return ServiceModel(
      title: serviceNameController.text,
      price: double.parse(servicePriceController.text),
      description: serviceDescriptionController.text,
      icon: serviceIconPath,
    );
  }

  // Update service
  void validateThenUpdateService(ServiceModel service) async {
    if (_validateService()) {
      emit(ServiceSaving());
      final ServiceModel updatedService = _constructService;
      final bool result = await _servicesRepo.updateService(
          _authData!.clinicIndex, updatedService);

      if (result) {
        emit(ServiceUpdated());
        final index = servicesList
            .indexWhere((element) => element.title == service.title);
        servicesList[index] = updatedService;
      } else {
        emit(ServiceError('Failed to update the service'));
      }
    }
    emit(ServicesSuccess(services: servicesList));
  }

  void _onSuccessOperation() async {
    emit(ServicesLoading());
    await refreshServices();
    emit(ServicesSuccess(services: servicesList));
  }

  Future<void> refreshServices() async {
    try {
      servicesList =
          await _servicesRepo.getServices(_authData!.clinicIndex, null);
    } catch (e) {
      emit(ServicesError('Failed to get the services'));
    }
  }

  // UI Logic
  void setupNewSheet() {
    serviceNameController.clear();
    servicePriceController.clear();
    serviceDescriptionController.clear();
    serviceIconPath = Assets.assetsImagesPngHeartRate;
  }

  void setupExistingSheet(ServiceModel service) {
    serviceNameController.text = service.title;
    servicePriceController.text = service.price.toString();
    serviceDescriptionController.text = service.description ?? '';
    serviceIconPath = service.icon;
  }

  void onIconChanged(String? value) {
    serviceIconPath = value ?? '';
  }
}
