import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String userName;
  final String password;
  final UserType role;

  UserModel({
    required this.id,
    required this.userName,
    required this.password,
    required this.role,
  });

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      id: snapshot.id,
      userName: data['userName'],
      password: data['password'],
      role:
          UserType.values.firstWhere((element) => element.name == data['role']),
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      userName: '',
      password: '',
      role: UserType.user,
    );
  }

  UserModel copyWith({
    String? id,
    String? userName,
    String? password,
    UserType? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userName': userName,
      'password': password,
      'role': role.name,
    };
  }

  bool get isEmpty {
    return id.isEmpty && userName.isEmpty && password.isEmpty;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, userName: $userName, password: $password, userType: $role)';
  }
}

enum UserType { admin, user }
