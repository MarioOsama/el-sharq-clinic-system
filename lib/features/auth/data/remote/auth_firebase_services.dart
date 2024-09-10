import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';

class AuthFirebaseServices {
  AuthFirebaseServices(this._firestore);

  final FirebaseFirestore _firestore;

  Future<AuthDataModel?> openWithUserNameAndPassword(
      int clinicIndex, String userName, String password) async {
    try {
      final clinicDoc = await _firestore
          .collection('clinics')
          .doc('clinic$clinicIndex')
          .get();

      // Get users collection with converter
      final usersCollection = await _getNestedCollection<UserModel>(
        clinicDoc,
        'users',
        (snapshot) => UserModel.fromFirestore(snapshot),
        (user) => user.toFirestore(),
      );
      final List<QueryDocumentSnapshot<UserModel>> userDocs =
          usersCollection.docs;

      // Check if user exists
      final UserModel user = userDocs.map((e) => e.data()).toList().firstWhere(
            (user) => user.userName == userName && user.password == password,
            orElse: () => UserModel.empty(),
          );

      log(user.toString());

      // If user exists
      if (!user.isEmpty) {
        return AuthDataModel(
          clinicIndex: clinicIndex,
          userModel: user,
          clinicName: clinicDoc.data()!['clinicName'],
          language: clinicDoc.data()!['language'],
          theme: clinicDoc.data()!['theme'],
          lowStockLimit: clinicDoc.data()!['lowStockLimit'],
        );
      }

      // If user doesn't exist
      return null;

      // When catching an error return null
    } catch (e) {
      return null;
    }
  }

  Future<QuerySnapshot<T>> _getNestedCollection<T>(
      DocumentSnapshot<Object?> doc,
      String collectionName,
      T Function(DocumentSnapshot<Map<String, dynamic>> snapshot) fromFirestore,
      Map<String, dynamic> Function(T object) toFirestore) async {
    return await doc.reference
        .collection(collectionName)
        .withConverter<T>(
          fromFirestore: (snapshot, options) => fromFirestore(snapshot),
          toFirestore: (value, options) => toFirestore(value),
        )
        .get();
  }

  Future<void> updatePreferences(AuthDataModel authData) async {
    final DocumentReference _clinicDoc = FirebaseFirestore.instance
        .collection('clinics')
        .doc('clinic${authData.clinicIndex}');

    await _clinicDoc.update({
      'language': authData.language,
      'theme': authData.theme,
      'lowStockLimit': authData.lowStockLimit,
    });
  }
}
