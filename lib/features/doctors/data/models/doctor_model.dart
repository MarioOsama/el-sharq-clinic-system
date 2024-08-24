import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String id;
  final String name;
  final String? email;
  final String? address;
  final String phone;
  final String? anotherPhone;
  final String? speciality;
  String? registrationDate;

  DoctorModel({
    required this.id,
    required this.name,
    this.email,
    this.address,
    required this.phone,
    this.anotherPhone,
    this.speciality,
    this.registrationDate,
  }) {
    if (registrationDate == null) {
      _setRegistrationDate;
    }
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? phone,
    String? anotherPhone,
    String? speciality,
    String? registrationDate,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      anotherPhone: anotherPhone ?? this.anotherPhone,
      speciality: speciality ?? this.speciality,
      registrationDate: registrationDate ?? this.registrationDate,
    );
  }

  factory DoctorModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoctorModel(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      address: data['address'],
      phone: data['phone'],
      anotherPhone: data['anotherPhone'],
      speciality: data['speciality'],
      registrationDate: data['registrationDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> doctorData = toMap();
    for (var key in doctorData.keys.toList()) {
      if (doctorData[key] == null ||
          doctorData[key].toString().trim().isEmpty ||
          doctorData[key] == 0) {
        doctorData.remove(key);
      }
    }
    return doctorData;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name.toLowerCase(),
      'email': email,
      'address': address,
      'phone': phone,
      'anotherPhone': anotherPhone,
      'speciality': speciality,
      'registrationDate': registrationDate,
    };
  }

  List<String> toList() {
    return [
      id,
      name,
      phone,
      registrationDate!.substring(0, 10),
      speciality ?? '',
      email ?? '',
      address ?? '',
      anotherPhone ?? '',
    ];
  }

  String get _setRegistrationDate =>
      registrationDate = DateTime.now().toString();
}
