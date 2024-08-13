import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFactory {
  FirebaseFactory._();

  static FirebaseFirestore? firestore;

  static FirebaseFirestore getFirestoreInstance() {
    firestore ??= FirebaseFirestore.instance;
    return firestore!;
  }
}
