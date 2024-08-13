import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String ownerName;
  final String phone;
  final String petName;
  final String petType;
  final DateTime date;
  final String time;
  final String petCondition;

  AppointmentModel({
    required this.id,
    required this.ownerName,
    required this.phone,
    required this.petName,
    required this.petType,
    required this.date,
    required this.time,
    required this.petCondition,
  });

  AppointmentModel copyWith({
    String? id,
    String? ownerName,
    String? phone,
    String? petName,
    String? petType,
    DateTime? date,
    String? time,
    String? petCondition,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      date: date ?? this.date,
      time: time ?? this.time,
      petCondition: petCondition ?? this.petCondition,
    );
  }

  factory AppointmentModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AppointmentModel(
      id: snapshot['id'],
      ownerName: snapshot['ownerName'],
      phone: snapshot['phone'],
      petName: snapshot['petName'],
      petType: snapshot['petType'],
      date: DateTime.parse(snapshot['date']),
      time: snapshot['time'],
      petCondition: snapshot['petCondition'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'ownerName': ownerName,
      'phone': phone,
      'petName': petName,
      'petType': petType,
      'date': date.toIso8601String(),
      'time': time,
      'petCondition': petCondition,
    };
  }
}
