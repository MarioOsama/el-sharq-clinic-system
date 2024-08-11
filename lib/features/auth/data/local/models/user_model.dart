import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String userName;
  final String password;

  UserModel({
    required this.id,
    required this.userName,
    required this.password,
  });

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      id: snapshot.id,
      userName: data['userName'],
      password: data['password'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'password': password,
    };
  }
}
