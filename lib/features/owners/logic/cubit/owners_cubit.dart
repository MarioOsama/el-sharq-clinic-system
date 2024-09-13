import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
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
  List<OwnerModel?> searchResult = [];
  List<bool> selectedRows = [];
  List<PetModel> deletedPetsList = [];
  List<PetModel> petsList = [
    PetModel(
      id: 'PET000',
      ownerId: 'ONR000',
      name: '',
      petReport: '',
      weight: 0,
      age: 0,
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
      emit(OwnersError(AppStrings.failedToGetOwners.tr()));
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
        emit(OwnersError(AppStrings.failedToGetOwners.tr()));
      }
    }
  }

  // Owner
  OwnerModel getOwnerById(String ownerId) {
    try {
      if (searchResult.isEmpty) {
        return ownersList.firstWhere((element) => element!.id == ownerId)
            as OwnerModel;
      } else {
        return searchResult.firstWhere((element) => element!.id == ownerId)
            as OwnerModel;
      }
    } catch (e) {
      emit(OwnersError(AppStrings.failedToGetOwners.tr()));
      rethrow;
    }
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
        emit(NewOwnerAdded());
        ownersList.insert(0, ownerInfo);
        _onSuccessOperation();
      } else {
        emit(OwnerError(AppStrings.failedToSaveOwnerAndPets.tr()));
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
      // Delete the removed owner pets if exist
      if (deletedPetsList.isNotEmpty) {
        final bool petsDeletionSuccess = await _deletePetsList();
        if (!petsDeletionSuccess) {
          emit(
            OwnerError(AppStrings.failedToUpdateOwnerPets.tr()),
          );
        }
      }
      if (!ownerUpdatingSuccess || !petsUpdatingSuccess) {
        emit(
          OwnerError(AppStrings.failedToUpdateOwnerInfo.tr()),
        );
      }
      emit(OwnerUpdated());
      final int index =
          ownersList.indexWhere((element) => element!.id == ownerInfo.id);
      ownersList[index] = ownerInfo;
      _onSuccessOperation();
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

  // Delete Owner
  void onDeleteSelectedOwners() async {
    emit(OwnersLoading());
    try {
      final List<String> deletedOwnersIds = [];
      // Get all the selected doctors
      for (int i = 0; i < selectedRows.length; i++) {
        if (selectedRows.elementAt(i)) {
          deletedOwnersIds.add(ownersList.elementAt(i)!.id);
        }
      }
      // Delete all the selected doctors
      for (String doctorId in deletedOwnersIds) {
        await _ownersRepo.deleteOwner(authData!.clinicIndex, doctorId);
        ownersList.removeWhere((element) => element!.id == doctorId);
      }
      _resetShowDeleteButtonNotifier();
      emit(OwnerDeleted());
      _onSuccessOperation();
    } catch (e) {
      emit(OwnersError(AppStrings.failedToDeleteSelectedCases.tr()));
    }
  }

  void onDeleteOwner(String id) async {
    emit(OwnersLoading());
    final bool deletionSuccess = await _deleteOwner(id);
    if (deletionSuccess) {
      emit(OwnerDeleted());
      ownersList.removeWhere((element) => element!.id == id);
      _onSuccessOperation();
    } else {
      emit(OwnersError(AppStrings.failedToDeleteOwnerProfile.tr()));
    }
  }

  Future<bool> _deleteOwner(String id) async {
    final OwnerModel owner = getOwnerById(id);
    final bool petsDeletionSuccess =
        await _deletePetsList(petsIds: owner.petsIds);
    final bool ownerDeletionSuccess =
        await _ownersRepo.deleteOwner(authData!.clinicIndex, id);
    if (!ownerDeletionSuccess || !petsDeletionSuccess) {
      return false;
    }
    return true;
  }

  Future<bool> _deletePetsList({List<String>? petsIds}) async {
    petsIds ??= deletedPetsList.map((pet) => pet.id).toList();
    bool success = true;
    for (int i = 0; i < petsIds.length; i++) {
      try {
        final successDeletion = await _deletePet(petsIds[i]);
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

  // Add owner pet
  void validateThenAddPet(String ownerId) async {
    if (petFormsKeys[0].currentState!.validate()) {
      emit(OwnerLoading());
      // Save pet form
      petFormsKeys[0].currentState!.save();
      // Set pet id and its owner id
      await _setPetIds(ownerId);
      // Add pet to firestore
      final bool petAddingSuccess =
          await _petsRepo.addPet(authData!.clinicIndex, ownerId, petsList[0]);
      // Update owner info on success of adding pet
      if (petAddingSuccess) {
        try {
          // Get owner to add pet to its pets list
          OwnerModel owner = getOwnerById(ownerId);
          owner.petsIds.add(petsList[0].id);
          // Update owner
          await _ownersRepo.updateOwner(authData!.clinicIndex, owner);
        } catch (e) {
          emit(OwnerError(AppStrings.failedToAddPet.tr()));
        }
      }
      emit(OwnerUpdated());
      _onSuccessOperation();
    }
  }

  Future<void> _setPetIds(String ownerId) async {
    // Get last pet id in firestore to set the next pet ids
    String? lastPetIdInFirestore = await getLastPetId();
    lastPetIdInFirestore = lastPetIdInFirestore!.getNextId(3, 'PET');
    petsList[0] =
        petsList[0].copyWith(id: lastPetIdInFirestore, ownerId: ownerId);
  }

  void _onSuccessOperation() async {
    selectedRows = List.filled(ownersList.length, false);
    emit(OwnersSuccess(owners: ownersList));
  }

  // Search
  void onSearch(String value) async {
    // Emit loading state to show loading indicator & refresh owners
    emit(OwnersLoading());
    // Search owners by phone number
    searchResult =
        await _ownersRepo.searchOwners(authData!.clinicIndex, value, 'phone');

    if (value.isEmpty || searchResult.isEmpty) {
      emit(OwnersSuccess(owners: ownersList));
      return;
    }

    emit(OwnersSuccess(owners: searchResult));
  }

  // UI Logic
  void setupNewSheet() {
    // Reset all data
    deletedPetsList = [];
    petsList = [
      PetModel(id: 'PET000', ownerId: 'ONR000', name: '', petReport: '')
    ];
    ownerInfo = OwnerModel(id: 'ONR000', name: '', phone: '', petsIds: []);
    petFormsKeys = [GlobalKey<FormState>()];
    numberOfPetsNotifier = ValueNotifier<int>(1);
  }

  void onSaveOwnerFormField(String field, String? value) {
    ownerInfo = ownerInfo.copyWith(
        name: field == AppStrings.name ? value : ownerInfo.name,
        phone: field == AppStrings.phone ? value : ownerInfo.phone,
        registrationDate:
            field == 'Registration Date' ? value : ownerInfo.registrationDate);
  }

  void onSavePetFormField(String field, String? value, int index) {
    final petModel = petsList[index];

    petsList[index] = petModel.copyWith(
      name: field == AppStrings.name ? value : petModel.name,
      gender: field == AppStrings.gender ? value : petModel.gender,
      age: field == AppStrings.age ? double.tryParse(value!) : petModel.age,
      type: field == AppStrings.type ? value : petModel.type,
      breed: field == AppStrings.breed ? value : petModel.breed,
      color: field == AppStrings.color ? value : petModel.color,
      weight: field == AppStrings.weight
          ? double.tryParse(value!)
          : petModel.weight,
      petReport: field == AppStrings.petReport ? value : petModel.petReport,
      vaccinations:
          field == AppStrings.vaccinations ? value : petModel.vaccinations,
      treatments: field == AppStrings.treatments ? value : petModel.treatments,
    );
  }

  Future<void> setupExistingOwnerSheet(OwnerModel owner) async {
    ownerFormKey = GlobalKey<FormState>();
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
        ownerId: 'ONR000',
        name: '',
        petReport: '',
        weight: 0,
        age: 0,
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

  void _resetShowDeleteButtonNotifier() {
    showDeleteButtonNotifier.value = false;
  }
}
