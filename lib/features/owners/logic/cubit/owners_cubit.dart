import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/owner_model.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/pet_model.dart';
import 'package:el_sharq_clinic/features/owners/data/local/repos/owners_repo.dart';
import 'package:el_sharq_clinic/features/owners/data/local/repos/pets_repo.dart';
import 'package:flutter/material.dart';

part 'owners_state.dart';

class OwnersCubit extends Cubit<OwnersState> {
  final OwnersRepo _ownersRepo;
  final PetsRepo _petsRepo;
  OwnersCubit(this._ownersRepo, this._petsRepo) : super(OwnersInitial());

  AuthDataModel? authData;
  ValueNotifier<int> numberOfPetsNotifier = ValueNotifier(1);
  ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);
  List<GlobalKey<FormState>> petFormsKeys = [GlobalKey<FormState>()];
  GlobalKey<FormState> ownerFormKey = GlobalKey<FormState>();

  List<OwnerModel?> ownersList = [];
  List<bool> selectedRows = [];
  List<PetModel> petsList = [
    PetModel(
      id: 'PET000',
      ownerId: null,
      name: '',
      petReport: '',
    ),
  ];
  OwnerModel ownerInfo = OwnerModel(
    id: 'ONR000',
    name: '',
    phone: '',
    petsIds: [],
  );

  int pageLength = 10;

  void setupSectionData(AuthDataModel authenticationData) {
    _setAuthData(authenticationData);
    _getPaginatedOwners();
  }

  void _setAuthData(AuthDataModel authenticationData) {
    authData = authenticationData;
  }

  void _getPaginatedOwners() async {
    emit(OwnersLoading());
    try {
      final List<OwnerModel> newOwnersList = await _ownersRepo.getOwners(
        authData!.clinicIndex,
        null,
      );
      log('New owners list length: ${newOwnersList.length}');

      ownersList.addAll(newOwnersList);
      log('Owners list length: ${ownersList.length}');
      selectedRows = List.filled(ownersList.length, false);
      emit(OwnersSuccess(owners: ownersList));
    } catch (e) {
      emit(OwnersError('Failed to get the owners'));
    }
  }

  void getNextPage(int firstIndex) async {
    String? lastOwnerId = ownersList.lastOrNull?.id;
    final String? lastOwnerIdInFirestore = await getFirstOwnerId();
    final bool isLastPage = ownersList.length - firstIndex <= pageLength;
    if (lastOwnerIdInFirestore.toString() != lastOwnerId.toString() &&
        isLastPage) {
      try {
        final List<OwnerModel> newOwnersList =
            await _ownersRepo.getOwners(authData!.clinicIndex, lastOwnerId);
        ownersList.addAll(newOwnersList);
        selectedRows = List.filled(ownersList.length, false);
        emit(OwnersSuccess(owners: ownersList));
      } catch (e) {
        emit(OwnersError('Failed to get the owners'));
      }
    }
  }

  // Owner
  OwnerModel? getOwnerById(String ownerId) {
    return ownersList.firstWhere((element) => element!.id == ownerId);
  }

  Future<String?> getLastOwnerId() async {
    return await _ownersRepo.getLastOwnerId(authData!.clinicIndex, true);
  }

  Future<String?> getFirstOwnerId() async {
    return await _ownersRepo.getLastOwnerId(authData!.clinicIndex, false);
  }

  // Pets
  Future<String?> getLastPetId() async {
    return await _petsRepo.getLastPetId(authData!.clinicIndex, true);
  }

  Future<void> refreshOwners() async {
    emit(OwnersLoading());
    try {
      ownersList = await _ownersRepo.getOwners(authData!.clinicIndex, null);
    } catch (e) {
      emit(OwnersError('Failed to get the owners'));
    }

    emit(OwnersSuccess(owners: ownersList));
  }

  void validateThenSave() async {
    if (_validateForms()) {
      emit(OwnersLoading());
      // Get last owner id in firestore to set the next owner id
      final String? lastOwnerIdInFirestore = await getLastOwnerId();
      // Get last pet id in firestore to set the next pet ids
      final String? lastPetIdInFirestore = await getLastPetId();
      // Save pet forms
      for (int i = 0; i < petFormsKeys.length; i++) {
        final petFormKey = petFormsKeys[i];
        petFormKey.currentState!.save();
      }
      // Save owner form
      ownerFormKey.currentState!.save();
      // Handle the next owner and pets ids
      _setOwnerAndPetsIds(
          lastOwnerIdInFirestore: lastOwnerIdInFirestore,
          lastPetIdInFirestore: lastPetIdInFirestore);
      // Save owner and pets
      final bool ownerSuccess = await _saveOwner();
      final bool petsSuccess = await _saveAllPets();
      // Take an action based on the success of the operation
      if (ownerSuccess && petsSuccess) {
        _onSuccessOperation();
      } else {
        emit(OwnersError('Failed to save the owner and pets'));
      }
    }
  }

  void _setOwnerAndPetsIds(
      {String? lastOwnerIdInFirestore, String? lastPetIdInFirestore}) {
    _setNextOwnerId(lastOwnerIdInFirestore);
    _setNextPetsIds(lastPetIdInFirestore);
    _setOwnerPetsIdsList(lastPetIdInFirestore);
    _setOwnerIdForEachPet();
  }

  List<PetModel> _setOwnerIdForEachPet() => petsList =
      petsList.map((pet) => pet.copyWith(ownerId: ownerInfo.id)).toList();

  void _setNextOwnerId(String? lastOwnerIdInFirestore) {
    if (lastOwnerIdInFirestore != null) {
      ownerInfo = ownerInfo.copyWith(
        id: lastOwnerIdInFirestore.getNextId(3, 'ONR'),
      );
    } else {
      ownerInfo = ownerInfo.copyWith(id: 'ONR001');
    }
  }

  void _setOwnerPetsIdsList(String? lastPetIdInFirestore) {
    ownerInfo = ownerInfo.copyWith(
      petsIds: petsList.map((pet) => pet.id).toList(),
    );
  }

  void _setNextPetsIds(String? lastPetIdInFirestore) {
    if (lastPetIdInFirestore != null) {
      petsList = petsList.map((pet) {
        lastPetIdInFirestore = lastPetIdInFirestore!.getNextId(3, 'PET');
        return pet.copyWith(id: lastPetIdInFirestore);
      }).toList();
    } else {
      lastPetIdInFirestore = 'PET000';
      petsList = petsList.map((pet) {
        lastPetIdInFirestore = lastPetIdInFirestore!.getNextId(3, 'PET');
        return pet.copyWith(id: lastPetIdInFirestore);
      }).toList();
    }
  }

  void onSaveOwnerFormField(String field, String? value) {
    ownerInfo = ownerInfo.copyWith(
      name: field == 'Name' ? value : ownerInfo.name,
      phone: field == 'Phone' ? value : ownerInfo.phone,
    );
  }

  void onSavePetFormField(String field, String? value, int index) {
    final petModel = petsList[index];

    petsList[index] = petModel.copyWith(
      name: field == 'Name' ? value : petModel.name,
      gender: field == 'Gender' ? value : petModel.gender,
      age: field == 'Age' ? double.tryParse(value!) : petModel.age,
      type: field == 'Type' ? value : petModel.type,
      breed: field == 'Breed' ? value : petModel.breed,
      color: field == 'Color' ? value : petModel.color,
      weight: field == 'Weight' ? double.tryParse(value!) : petModel.weight,
      petReport: field == 'Pet Report' ? value : petModel.petReport,
      vaccinations: field == 'Vaccinations' ? value : petModel.vaccinations,
      treatments: field == 'Treatments' ? value : petModel.treatments,
    );
  }

  Future<bool> _saveOwner() async {
    return await _ownersRepo.addNewOwner(authData!.clinicIndex, ownerInfo);
  }

  Future<bool> _savePet(PetModel petModel) async {
    return await _petsRepo.addPet(
        authData!.clinicIndex, ownerInfo.id, petModel);
  }

  Future<bool> _saveAllPets() async {
    bool success = true;
    for (final pet in petsList) {
      success = await _savePet(pet);
      if (!success) {
        success = false;
        break;
      }
    }
    return success;
  }

  void _onSuccessOperation() async {
    await refreshOwners();
    selectedRows = List.filled(ownersList.length, false);
    emit(OwnersSuccess(owners: ownersList));
  }

  // UI Logic
  void setupNewSheet() {
    numberOfPetsNotifier = ValueNotifier<int>(1);
  }

  void setupExistingSheet(OwnerModel owner) {
    numberOfPetsNotifier = ValueNotifier<int>(owner.petsIds.length);
    petFormsKeys = List.generate(
      owner.petsIds.length,
      (index) => GlobalKey<FormState>(),
    );
    // Set owner info
    ownerInfo = owner;
  }

  void incrementPets() {
    numberOfPetsNotifier.value++;
    petFormsKeys.add(GlobalKey<FormState>());
    petsList.add(
      PetModel(
        id: 'PET000',
        ownerId: null,
        name: '',
        petReport: '',
      ),
    );
    emit(OwnersPetsChanged(numberOfPetsNotifier.value));
  }

  void decrementPets(int index) {
    numberOfPetsNotifier.value--;
    petFormsKeys.removeAt(index);
    petsList.removeAt(index);
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
}
