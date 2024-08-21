import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String id;
  final String name;
  final String? email;
  final String? address;
  final String phoneNumber;
  final String? anotherPhoneNumber;
  final String? speciality;
  String? registrationDate;

  DoctorModel({
    required this.id,
    required this.name,
    this.email,
    this.address,
    required this.phoneNumber,
    this.anotherPhoneNumber,
    this.speciality,
    this.registrationDate,
  }) {
    _setRegistrationDate;
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? phoneNumber,
    String? anotherPhoneNumber,
    String? speciality,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      anotherPhoneNumber: anotherPhoneNumber ?? this.anotherPhoneNumber,
      speciality: speciality ?? this.speciality,
    );
  }

  factory DoctorModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoctorModel(
      id: doc.id,
      name: data['name'] as String,
      email: data['email'] as String,
      address: data['address'] as String,
      phoneNumber: data['phoneNumber'] as String,
      anotherPhoneNumber: data['anotherPhoneNumber'] as String,
      speciality: data['speciality'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> doctorData = toMap();
    for (var key in doctorData.keys.toList()) {
      if (doctorData[key].toString().trim().isEmpty ||
          doctorData[key] == null ||
          doctorData[key] == 0) {
        doctorData.remove(key);
      }
    }
    return doctorData;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'anotherPhoneNumber': anotherPhoneNumber,
      'speciality': speciality,
    };
  }

  List<String> toList() {
    return [
      id,
      name,
      phoneNumber,
      speciality ?? '',
      email ?? '',
      address ?? '',
      anotherPhoneNumber ?? '',
    ];
  }

  String get _setRegistrationDate =>
      registrationDate = DateTime.now().toString();
}
