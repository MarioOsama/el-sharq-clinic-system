import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';

class AuthFirebaseServices {
  AuthFirebaseServices(this._firestore);

  final FirebaseFirestore _firestore;

  Future<QueryDocumentSnapshot<UserModel>?> openWithUserNameAndPassword(
      int clinicIndex, String userName, String password) async {
    final clinicDoc =
        await _firestore.collection('clinics').doc('clinic$clinicIndex').get();

    // Get users collection with converter
    final usersCollection = await _getNestedCollection(
      clinicDoc,
      'users',
      (snapshot) => UserModel.fromFirestore(snapshot),
      (user) => user.toFirestore(),
    );

    try {
      return usersCollection.docs.firstWhere(
        (user) =>
            user.data().userName == userName &&
            user.data().password == password,
      );
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

  // Future<void> signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }
  //
  //
  // Future<void> updatePassword(String password) async {
  //   await FirebaseAuth.instance.currentUser!.updatePassword(password);
  // }
  //
  // Future<void> updateEmail(String email) async {
  //   await FirebaseAuth.instance.currentUser!.updateEmail(email);
  // }
  //
  // Future<void> deleteAccount() async {
  //   await FirebaseAuth.instance.currentUser!.delete();
  // }
}
