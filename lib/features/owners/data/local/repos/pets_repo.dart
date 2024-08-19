import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/pet_model.dart';

class PetsRepo {
  final FirebaseServices _firebaseServices;

  PetsRepo(this._firebaseServices);

  Future<bool> addPet(
      int clinicIndex, String ownerId, PetModel petModel) async {
    return await _firebaseServices.addItem<PetModel>(
      'pets',
      clinicIndex: clinicIndex,
      itemModel: petModel,
      id: petModel.id,
      toFirestore: petModel.toFirestore,
      idScheme: 'PET',
    );
  }

  Future<String?> getLastPetId(int clinicIndex, bool descendingOrder) async {
    return await _firebaseServices.getFirstItemId(
      'pets',
      clinicIndex: clinicIndex,
      descendingOrder: descendingOrder,
    );
  }
}
