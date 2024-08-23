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
      // Check if service name already exists

      final ServiceModel service = _constructService();
      if (servicesList.any((element) => element.title == service.title)) {
        emit(ServiceError('Service name already exists'));
        return;
      }
      // Save service
      emit(ServiceSaving());
      final bool result =
          await _servicesRepo.addService(_authData!.clinicIndex, service);

      if (result) {
        emit(ServiceAdded());
        servicesList.add(service);
      } else {
        emit(ServiceError('Failed to add the service'));
      }
      _onSuccessOperation();
    }
  }

  bool _validateService() {
    bool valid = false;
    if (serviceNameController.text.isEmpty) {
      emit(ServiceError('Service name is required'));
    } else if (servicePriceController.text.isEmpty ||
        double.tryParse(servicePriceController.text) == null ||
        double.parse(servicePriceController.text) <= 0) {
      emit(ServiceError(
          'Service price is required, and must be a positive number greater than 0'));
    } else {
      valid = true;
    }
    return valid;
  }

  ServiceModel _constructService({String? id}) {
    return ServiceModel(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: serviceNameController.text,
      price: double.parse(servicePriceController.text),
      description: serviceDescriptionController.text,
      icon: serviceIconPath,
    );
  }

  // Update service
  void validateThenUpdateService(ServiceModel currentservice) async {
    if (_validateService()) {
      // Check if service name already exists
      final servicesWithSameName = servicesList
          .where((service) =>
              service.title == serviceNameController.text &&
              service.id != currentservice.id)
          .toList();
      if (servicesWithSameName.isNotEmpty) {
        emit(ServiceError('Service name already exists'));
        return;
      }
      // Update service
      emit(ServiceSaving());
      final ServiceModel updatedService =
          _constructService(id: currentservice.id);
      final bool result = await _servicesRepo.updateService(
          _authData!.clinicIndex, updatedService);

      if (result) {
        emit(ServiceUpdated());
        final int index = servicesList
            .indexWhere((service) => service.id == currentservice.id);
        servicesList[index] = updatedService;
      } else {
        emit(ServiceError('Failed to update the service'));
      }
      _onSuccessOperation();
    }
  }

  // Delete service
  void deleteService(ServiceModel service) async {
    emit(ServicesLoading());
    final bool result =
        await _servicesRepo.deleteService(_authData!.clinicIndex, service);
    if (result) {
      emit(ServiceDeleted());
      servicesList.removeWhere((element) => element.id == service.id);
    } else {
      emit(ServiceError('Failed to delete the service'));
    }
    emit(ServicesSuccess(services: servicesList));
  }

  void _onSuccessOperation() async {
    emit(ServicesLoading());
    Future.delayed(const Duration(seconds: 1), () {
      emit(ServicesSuccess(services: servicesList));
    });
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
    serviceIconPath = Assets.assetsImagesPngDoubleMedicine;
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
