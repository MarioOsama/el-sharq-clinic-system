import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerModel {
  final String? id;
  final String name;
  final String phone;
  final List<String> petsIds;
  String? registrationDate;

  OwnerModel({
    this.id,
    required this.name,
    required this.phone,
    required this.petsIds,
    this.registrationDate,
  }) {
    registrationDate ??= DateTime.now().toIso8601String().substring(0, 10);
  }

  factory OwnerModel.fromFirestore(QueryDocumentSnapshot doc) {
    return OwnerModel(
      id: doc.id,
      name: doc['name'],
      phone: doc['phone'],
      petsIds: doc['petsIds'],
      registrationDate: doc['registrationDate'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id ?? '',
      'name': name,
      'phone': phone,
      'petsIds': petsIds,
    };
  }
}
