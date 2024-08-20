import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/owner_model.dart';

class OwnersRepo {
  final FirebaseServices _firebaseServices;

  OwnersRepo(this._firebaseServices);

  Future<List<OwnerModel>> getOwners(
      int clinicIndex, String? lastOwnerId) async {
    return await _firebaseServices.getItems<OwnerModel>(
      'owners',
      clinicIndex: clinicIndex,
      fromFirestore: OwnerModel.fromFirestore,
      lastId: lastOwnerId,
    );
  }

  Future<String?> getLastOwnerId(int clinicIndex, bool descendingOrder) async {
    return await _firebaseServices.getFirstItemId(
      'owners',
      clinicIndex: clinicIndex,
      descendingOrder: descendingOrder,
    );
  }

  Future<bool> addNewOwner(int clinicIndex, OwnerModel ownerModel) async {
    return await _firebaseServices.addItem<OwnerModel>(
      'owners',
      id: ownerModel.id,
      clinicIndex: clinicIndex,
      itemModel: ownerModel,
      toFirestore: ownerModel.toFirestore,
      idScheme: 'ONR',
    );
  }

  Future<bool> updateOwner(int clinicIndex, OwnerModel ownerModel) async {
    return await _firebaseServices.updateItem<OwnerModel>(
      'owners',
      itemModel: ownerModel,
      id: ownerModel.id,
      toFirestore: ownerModel.toFirestore,
      clinicIndex: clinicIndex,
    );
  }
}
