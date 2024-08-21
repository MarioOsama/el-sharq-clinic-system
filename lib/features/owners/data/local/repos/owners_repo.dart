import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/owners/data/local/models/owner_model.dart';

class OwnersRepo {
  final FirebaseServices _firebaseServices;

  OwnersRepo(this._firebaseServices);

  final String collectionName = 'owners';

  Future<List<OwnerModel>> getOwners(
      int clinicIndex, String? lastOwnerId) async {
    return await _firebaseServices.getItems<OwnerModel>(
      collectionName,
      clinicIndex: clinicIndex,
      fromFirestore: OwnerModel.fromFirestore,
      lastId: lastOwnerId,
    );
  }

  Future<String?> getLastOwnerId(int clinicIndex, bool descendingOrder) async {
    return await _firebaseServices.getFirstItemId(
      collectionName,
      clinicIndex: clinicIndex,
      descendingOrder: descendingOrder,
    );
  }

  Future<bool> addNewOwner(int clinicIndex, OwnerModel ownerModel) async {
    return await _firebaseServices.addItem<OwnerModel>(
      collectionName,
      id: ownerModel.id,
      clinicIndex: clinicIndex,
      itemModel: ownerModel,
      toFirestore: ownerModel.toFirestore,
      idScheme: 'ONR',
    );
  }

  Future<bool> updateOwner(int clinicIndex, OwnerModel ownerModel) async {
    return await _firebaseServices.updateItem<OwnerModel>(
      collectionName,
      itemModel: ownerModel,
      id: ownerModel.id,
      toFirestore: ownerModel.toFirestore,
      clinicIndex: clinicIndex,
    );
  }

  Future<bool> deleteOwner(int clinicIndex, String id) async {
    return await _firebaseServices.deleteItem(
      collectionName,
      id: id,
      clinicIndex: clinicIndex,
    );
  }

  Future<List<OwnerModel>> searchOwners(
      int clinicIndex, String name, String field) async {
    return await _firebaseServices.getItemsByField<OwnerModel>(collectionName,
        clinicIndex: clinicIndex,
        field: field,
        value: name,
        fromFirestore: OwnerModel.fromFirestore);
  }
}
