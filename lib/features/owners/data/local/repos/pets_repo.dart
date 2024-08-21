import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/pet_model.dart';

class PetsRepo {
  final FirebaseServices _firebaseServices;

  PetsRepo(this._firebaseServices);

  final String collectionName = 'pets';

  Future<bool> addPet(
      int clinicIndex, String ownerId, PetModel petModel) async {
    return await _firebaseServices.addItem<PetModel>(
      collectionName,
      clinicIndex: clinicIndex,
      itemModel: petModel,
      id: petModel.id,
      toFirestore: petModel.toFirestore,
    );
  }

  Future<String?> getLastPetId(int clinicIndex, bool descendingOrder) async {
    return await _firebaseServices.getFirstItemId(
      collectionName,
      clinicIndex: clinicIndex,
      descendingOrder: descendingOrder,
    );
  }

  Future<List<PetModel>> getPetsByIds(int clinicIndex, List<String> ids) async {
    return _firebaseServices.getItemsByIds<PetModel>(collectionName,
        clinicIndex: clinicIndex,
        ids: ids,
        fromFirestore: PetModel.fromFirestore);
  }

  Future<bool> updatePet(int clinicIndex, PetModel petModel) async {
    return _firebaseServices.updateItem<PetModel>(
      collectionName,
      itemModel: petModel,
      id: petModel.id,
      toFirestore: petModel.toFirestore,
      clinicIndex: clinicIndex,
    );
  }

  Future<bool> deletePet(int clinicIndex, String id) async {
    return await _firebaseServices.deleteItem(
      collectionName,
      id: id,
      clinicIndex: clinicIndex,
    );
  }
}
