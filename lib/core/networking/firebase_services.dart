import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';

class FirebaseServices {
  FirebaseServices(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<T>> getItems<T>(
    String collectionName, {
    required int clinicIndex,
    required T Function(QueryDocumentSnapshot<Object?> doc) fromFirestore,
    String? lastId,
    int limit = 21,
    bool descendingOrder = true,
  }) async {
    // Get the clinic document reference
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);

    Query query;

    // Create the query with pagination
    if (limit == -1) {
      query = targetedCollection.orderBy(FieldPath.documentId,
          descending: descendingOrder);
    } else {
      query = targetedCollection
          .orderBy(FieldPath.documentId, descending: descendingOrder)
          .limit(limit);
    }

    // If there is a lastItem, start after its document ID
    if (lastId != null) {
      final String lastIdInCollection = await targetedCollection
          .orderBy(FieldPath.documentId)
          .limit(1)
          .get()
          .then((value) => value.docs.first.id);

      if (lastIdInCollection == lastId) {
        return [];
      }

      query = query.startAfter([lastId]);
    }

    // Execute the query and get the documents
    final QuerySnapshot querySnapshot = await query.get();

    // Map the documents to your model
    final List<T> items = querySnapshot.docs.map((doc) {
      return fromFirestore(doc);
    }).toList();

    // Return the list of T
    return items;
  }

  Future<String?> getFirstItemId(String collectionName,
      {required int clinicIndex, required bool descendingOrder}) async {
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);
    final String? lastItemId = await targetedCollection
        .orderBy(FieldPath.documentId, descending: descendingOrder)
        .limit(1)
        .get()
        .then((value) {
      try {
        return value.docs.first.id;
      } catch (e) {
        return null;
      }
    });

    return lastItemId;
  }

  Future<bool> addItem<T>(String collectionName,
      {required String id,
      required T itemModel,
      required Map<String, dynamic> Function() toFirestore,
      required int clinicIndex}) async {
    // Get clinic document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);

    // Add new [itemModel] to clinic [collectionName] collection
    try {
      await targetedCollection.doc(id).set(toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateItem<T>(String collectionName,
      {required T itemModel,
      required String id,
      required Map<String, dynamic> Function() toFirestore,
      required int clinicIndex}) async {
    // Get clinic document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);
    // Check if fields are deleted
    final Map<String, dynamic> itemMap = toFirestore();
    // Update item
    try {
      final targetedDoc = await targetedCollection.doc(id).get();
      if (targetedDoc.exists && targetedDoc.data()!.keys == itemMap.keys) {
        await targetedCollection.doc(id).update(itemMap);
      } else {
        await targetedCollection.doc(id).set(toFirestore());
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteItem(String collectionName,
      {required String id, required int clinicIndex}) async {
    // Get clinic document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);
    try {
      await targetedCollection.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getClinicDoc(
      int clinicIndex) async {
    return await _firestore
        .collection('clinics')
        .doc('clinic$clinicIndex')
        .get();
  }

  Future<List<T>> getItemsByIds<T>(
    String collectionName, {
    required int clinicIndex,
    required List<String> ids,
    required T Function(QueryDocumentSnapshot<Object?> doc) fromFirestore,
  }) async {
    // Get the clinic document reference
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);

    // Create the query with pagination
    Query query = targetedCollection.where(FieldPath.documentId, whereIn: ids);

    // Get query data
    QuerySnapshot dataSnapshot = await query.get();

    // Converting [dataSnapshot] into T type
    final List<T> items =
        dataSnapshot.docs.map((doc) => fromFirestore(doc)).toList();

    return items;
  }

  Future<List<T>> getItemsByField<T>(
    String collectionName, {
    required int clinicIndex,
    required String field,
    required String value,
    required T Function(QueryDocumentSnapshot<Object?> doc) fromFirestore,
  }) async {
    // Get the clinic document reference
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);

    final QuerySnapshot querySnapshot = await _firestore
        .collection(targetedCollection.path)
        .where(field, isGreaterThanOrEqualTo: value.toLowerCase())
        .where(field, isLessThan: '$value\uf7ff')
        .get();

    // Converting [dataSnapshot] into T type
    final List<T> items =
        querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();

    return items;
  }

  Future<List<T>> getDocsByDate<T>(
    String collectionName, {
    required int clinicIndex,
    required String dateField,
    required DateTime startDate,
    required T Function(QueryDocumentSnapshot<Object?> doc) fromFirestore,
    DateTime? endDate,
  }) async {
    // Get the clinic document reference
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);

    startDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      0,
      0,
      0,
    );

    endDate = endDate ??
        DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          23,
          59,
          59,
          999,
        );

    // Query Firestore
    QuerySnapshot snapshot = await _firestore
        .collection(targetedCollection.path)
        .where(dateField, isGreaterThanOrEqualTo: startDate.toString())
        .where(dateField, isLessThanOrEqualTo: endDate.toString())
        .get();

    // Converting [dataSnapshot] into T type
    final List<T> items =
        snapshot.docs.map((doc) => fromFirestore(doc)).toList();

    return items;
  }

  Future<List<T>> getDocsByStringDate<T>(
    String collectionName, {
    required int clinicIndex,
    required String dateField,
    required String stringStartDate,
    required T Function(QueryDocumentSnapshot<Object?> doc) fromFirestore,
    String? stringEndDate,
  }) async {
    // Get the clinic document reference
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);

    // Query Firestore
    QuerySnapshot snapshot = await _firestore
        .collection(targetedCollection.path)
        .where(dateField,
            isGreaterThanOrEqualTo: stringStartDate.substring(0, 10))
        .where(dateField,
            isLessThanOrEqualTo:
                stringEndDate ?? stringStartDate.substring(0, 10))
        .get();

    // Converting [dataSnapshot] into T type
    final List<T> items =
        snapshot.docs.map((doc) => fromFirestore(doc)).toList();

    return items;
  }

  Future<List<T>> getItemsEqualOrLessValue<T>(
    String collectionName, {
    required int clinicIndex,
    required String field,
    required int value,
    required T Function(QueryDocumentSnapshot<Object?> doc) fromFirestore,
  }) async {
    // Get the clinic document reference
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final targetedCollection = clinicDoc.reference.collection(collectionName);
    final QuerySnapshot querySnapshot = await _firestore
        .collection(targetedCollection.path)
        .where(field, isLessThanOrEqualTo: value)
        .get();

    // Converting [dataSnapshot] into T type
    final List<T> items =
        querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();

    return items;
  }

  Future<UserModel> getAdminUser(int clinicIndex) async {
    // Fetch the clinic document
    final clinicDoc = await _getClinicDoc(clinicIndex);

    // Access the 'users' sub-collection within the clinic document
    final targetedCollection = clinicDoc.reference.collection('users');

    // Query Firestore for user with the role 'admin'
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await targetedCollection
            .where('role', isEqualTo: 'admin')
            .limit(1)
            .get();

    // Convert querySnapshot into List<UserModel>
    final UserModel user = querySnapshot.docs
        .map((doc) => UserModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .first;

    return user;
  }
}
