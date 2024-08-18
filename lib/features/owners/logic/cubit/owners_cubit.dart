import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'owners_state.dart';

class OwnersCubit extends Cubit<OwnersState> {
  OwnersCubit() : super(OwnersInitial());

  ValueNotifier<int> numberOfPetsNotifier = ValueNotifier(1);
  GlobalKey<FormState> ownerFormKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> petFormsKeys = [GlobalKey<FormState>()];

  void setupNewSheet() {
    numberOfPetsNotifier = ValueNotifier<int>(1);
  }

  void incrementPets() {
    numberOfPetsNotifier.value++;
    petFormsKeys.add(GlobalKey<FormState>());
    emit(OwnersPetsChanged(numberOfPetsNotifier.value));
  }

  void decrementPets(int index) {
    numberOfPetsNotifier.value--;
    petFormsKeys.removeAt(index);
    emit(OwnersPetsChanged(numberOfPetsNotifier.value));
  }

  bool _validateForms() {
    bool isValid = true;
    // Validate owner form
    if (!ownerFormKey.currentState!.validate()) {
      isValid = false;
    }
    // Validate pet forms
    for (final formKey in petFormsKeys) {
      if (!formKey.currentState!.validate()) {
        isValid = false;
      }
    }
    return isValid;
  }

  void validateThenSave() {
    if (_validateForms()) {
      log('All forms are valid');
    } else {
      log('Some forms are invalid');
    }
  }
}
