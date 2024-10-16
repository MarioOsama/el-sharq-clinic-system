import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/networking/firebase_services.dart';

abstract class GeneralRepo<T> {
  final String collectionName;

  // FirebaseServices instance is now passed through the constructor.
  final FirebaseServices firebaseServices;

  // Constructor to inject the Firebase services instance
  GeneralRepo(this.firebaseServices, this.collectionName);

  Future<List<T>> getAllItems(int clinicIndex, String? lastItemId,
      T Function(QueryDocumentSnapshot<Object?> doc) fromFirestore) {
    try {
      return firebaseServices.getItems<T>(
        collectionName,
        clinicIndex: clinicIndex,
        fromFirestore: fromFirestore,
        lastId: lastItemId,
      );
    } catch (e) {
      return Future.value([]);
    }
  }

  Future<String?> getFirstItemId(int clinicIndex, bool descendingOrder) {
    return firebaseServices.getFirstItemId(
      collectionName,
      clinicIndex: clinicIndex,
      descendingOrder: descendingOrder,
    );
  }

  Future<bool> addNewItem(T itemModel, int clinicIndex) {
    return firebaseServices.addItem<T>(
      collectionName,
      clinicIndex: clinicIndex,
      itemModel: itemModel,
      id: (itemModel as dynamic).id,
      toFirestore: (itemModel as dynamic).toFirestore,
    );
  }

  Future<bool> updateItem(T itemModel, int clinicIndex) {
    return firebaseServices.updateItem<T>(
      collectionName,
      itemModel: itemModel,
      clinicIndex: clinicIndex,
      toFirestore: (itemModel as dynamic).toFirestore,
      id: (itemModel as dynamic).id,
    );
  }

  Future<bool> deleteItem(String itemId, int clinicIndex) {
    return firebaseServices.deleteItem(
      collectionName,
      id: itemId,
      clinicIndex: clinicIndex,
    );
  }

  Future<List<T>> searchItems(int clinicIndex, String value, String field) {
    return firebaseServices.getItemsByField<T>(
      collectionName,
      clinicIndex: clinicIndex,
      field: field,
      value: value,
      fromFirestore: (T as dynamic).fromFirestore,
    );
  }
}
