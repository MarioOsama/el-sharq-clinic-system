import 'package:cloud_firestore/cloud_firestore.dart';

class OwnerModel {
  final String id;
  final String name;
  final String phone;
  final List<String> petsIds;
  String? registrationDate;

  OwnerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.petsIds,
    this.registrationDate,
  }) {
    _setRegistrationDate;
  }

  factory OwnerModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    return OwnerModel(
      id: doc.id,
      name: doc['name'],
      phone: doc['phone'],
      petsIds: doc['petsIds'].cast<String>(),
      registrationDate: doc['registrationDate'],
    );
  }

  OwnerModel copyWith({
    String? id,
    String? name,
    String? phone,
    List<String>? petsIds,
    String? registrationDate,
  }) {
    return OwnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      petsIds: petsIds ?? this.petsIds,
      registrationDate: registrationDate ?? this.registrationDate,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'petsIds': petsIds,
      'registrationDate': registrationDate,
    };
  }

  List<String> toList() {
    return [
      id,
      name,
      phone,
      petsIds.length.toString(),
      registrationDate!.substring(0, 10),
    ];
  }

  String get _setRegistrationDate =>
      registrationDate = DateTime.now().toString();

  @override
  String toString() {
    return 'OwnerModel{id: $id, name: $name, phone: $phone, petsIds: $petsIds, registrationDate: $registrationDate}';
  }
}
