import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';

class AuthFirebaseServices {
  AuthFirebaseServices(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<String>> getAllClinicNames() async {
    final snapshot = await _firestore.collection('clinics').get();
    return snapshot.docs
        .map((e) => e.data()['clinicName'])
        .toList()
        .cast<String>();
  }

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
    final DocumentReference clinicDoc = FirebaseFirestore.instance
        .collection('clinics')
        .doc('clinic${authData.clinicIndex}');

    await clinicDoc.update({
      'clinicName': authData.clinicName,
      'language': authData.language,
      'theme': authData.theme,
      'lowStockLimit': authData.lowStockLimit,
    });
  }

  Future<void> updateUserPassword(
      AuthDataModel authData, String newPassword) async {
    final DocumentReference clinicDoc = FirebaseFirestore.instance
        .collection('clinics')
        .doc('clinic${authData.clinicIndex}');

    final DocumentReference userDoc = clinicDoc
        .collection('users')
        .doc(authData.userModel.id); // Get user document

    await userDoc.update({
      'password': newPassword,
    });
  }

  Future<void> addUserAccount(AuthDataModel authData, UserModel newUser) async {
    final DocumentReference clinicDoc =
        _firestore.collection('clinics').doc('clinic${authData.clinicIndex}');

    await clinicDoc
        .collection('users')
        .doc(newUser.id)
        .set(newUser.toFirestore());
  }

  Future<void> deleteUserAccount(AuthDataModel authData, String userId) async {
    final DocumentReference clinicDoc =
        _firestore.collection('clinics').doc('clinic${authData.clinicIndex}');

    await clinicDoc.collection('users').doc(userId).delete();
  }

  Future<List<UserModel>> getClinicUsers(AuthDataModel authData) async {
    final clinicDoc = await _firestore
        .collection('clinics')
        .doc('clinic${authData.clinicIndex}')
        .get();

    final usersCollection = await _getNestedCollection<UserModel>(
      clinicDoc,
      'users',
      (snapshot) => UserModel.fromFirestore(snapshot),
      (user) => user.toFirestore(),
    );

    return usersCollection.docs.map((e) => e.data()).toList();
  }
}
