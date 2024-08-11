import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/features/data/local/models/user_model.dart';

class AuthFirebaseServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<QueryDocumentSnapshot<UserModel>?> openWithUserNameAndPassword(
      int clinicIndex, String userName, String password) async {
    // Get Clinic Info Document
    final DocumentSnapshot clinicInfoDoc =
        await _getClinicDoc(clinicIndex, 'clinic-info');

    // Get Users Collection inside the Clinic Info Document
    final clinicUsers = await _getDocCollection(
      clinicInfoDoc,
      'users',
      UserModel.fromFirestore,
      (user) => user.toFirestore(),
    );

    // Check if the user exists in the users collection
    try {
      return clinicUsers.docs.firstWhere(
        (user) =>
            user.data().userName == userName &&
            user.data().password == password,
      );
    } catch (e) {
      return null;
    }
  }

  Future<DocumentSnapshot> _getClinicDoc(
      int clinicIndex, String docName) async {
    return await firestore.collection('clinic$clinicIndex').doc(docName).get();
  }

  Future<QuerySnapshot<T>> _getDocCollection<T>(
      DocumentSnapshot<Object?> clinicDoc,
      String collectionName,
      T Function(DocumentSnapshot<Map<String, dynamic>> snapshot) fromFirestore,
      Map<String, dynamic> Function(T object) toFirestore) async {
    return await clinicDoc.reference
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
