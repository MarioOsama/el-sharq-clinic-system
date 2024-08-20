import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/owner_model.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/pet_model.dart';
import 'package:el_sharq_clinic/features/owners/data/local/repos/owners_repo.dart';
import 'package:el_sharq_clinic/features/owners/data/local/repos/pets_repo.dart';
import 'package:flutter/cupertino.dart';
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
  List<PetModel> deletedPetsList = [];
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

      ownersList.addAll(newOwnersList);
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
  OwnerModel getOwnerById(String ownerId) {
    return ownersList.firstWhere((element) => element!.id == ownerId)
        as OwnerModel;
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

  Future<void> getPetsByIds(List<String> ids) async {
    petsList = await _petsRepo.getPetsByIds(authData!.clinicIndex, ids);
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

  // Save New Owner
  void validateThenSave() async {
    if (_validateForms()) {
      emit(OwnerLoading());
      // Get last owner id in firestore to set the next owner id
      final String? lastOwnerIdInFirestore = await getLastOwnerId();
      // Get last pet id in firestore to set the next pet ids
      final String? lastPetIdInFirestore = await getLastPetId();
      // Save owner form and pet forms
      _savePetForms();
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
        emit(NewOwnerAdded());
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

  // Update Owner
  void validateThenUpdate() async {
    if (_validateForms()) {
      emit(OwnerLoading());
      // Save owner form and pet forms
      _savePetForms();
      ownerFormKey.currentState!.save();
      // Update
      final bool ownerUpdatingSuccess = await _updateOwner();
      final bool petsUpdatingSuccess = await _updatePetsList();
      if (deletedPetsList.isNotEmpty) {
        final bool petsDeletionSuccess = await _deletePetsList();
        if (!petsDeletionSuccess) {
          emit(
            OwnersError('Failed to update owner pets info'),
          );
        }
      }
      if (!ownerUpdatingSuccess || !petsUpdatingSuccess) {
        emit(
          OwnersError('Failed to update owner info'),
        );
      }
      _onSuccessOperation();
      emit(OwnerUpdated());
    }
  }

  Future<bool> _updateOwner() async {
    return await _ownersRepo.updateOwner(authData!.clinicIndex, ownerInfo);
  }

  Future<bool> _updatePetsList() async {
    bool success = true;
    for (int i = 0; i < petsList.length; i++) {
      try {
        final successUpdating = await _updatePet(petsList[i]);
        if (!successUpdating) {
          success = false;
          break;
        }
      } catch (e) {
        success = false;
        break;
      }
    }
    return success;
  }

  Future<bool> _updatePet(PetModel pet) async {
    return await _petsRepo.updatePet(authData!.clinicIndex, pet);
  }

  Future<bool> _deletePetsList() async {
    bool success = true;
    for (int i = 0; i < deletedPetsList.length; i++) {
      try {
        final successDeletion = await _deletePet(deletedPetsList[i].id);
        if (!successDeletion) {
          success = false;
          break;
        }
      } catch (e) {
        success = false;
        break;
      }
    }
    return success;
  }

  Future<bool> _deletePet(String id) async {
    return await _petsRepo.deletePet(authData!.clinicIndex, id);
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

  Future<void> setupExistingOwnerSheet(OwnerModel owner) async {
    // Set owner info
    ownerInfo = owner;
    // Set pets info
    await getPetsByIds(ownerInfo.petsIds);
    // Setup pet forms and notifier.
    numberOfPetsNotifier = ValueNotifier<int>(ownerInfo.petsIds.length);
    petFormsKeys = List.generate(
      ownerInfo.petsIds.length,
      (index) => GlobalKey<FormState>(),
    );
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
    // Add the removed pet to the list to remove it when the user updating owner
    final deletedPet = petsList.removeAt(index);
    ownerInfo.petsIds.remove(deletedPet.id);
    deletedPetsList.add(deletedPet);
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

  void _savePetForms() {
    for (int i = 0; i < petFormsKeys.length; i++) {
      final petFormKey = petFormsKeys[i];
      petFormKey.currentState!.save();
    }
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
