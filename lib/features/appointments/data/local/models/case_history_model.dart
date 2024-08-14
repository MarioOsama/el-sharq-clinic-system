import 'package:cloud_firestore/cloud_firestore.dart';

class CaseHistoryModel {
  final String? id;
  final String ownerName;
  final String phone;
  final String petName;
  final String petType;
  final String date;
  final String time;
  final String petReport;

  CaseHistoryModel({
    this.id,
    required this.ownerName,
    required this.phone,
    required this.petName,
    required this.petType,
    required this.date,
    required this.time,
    required this.petReport,
  });

  CaseHistoryModel copyWith({
    String? id,
    String? ownerName,
    String? phone,
    String? petName,
    String? petType,
    String? date,
    String? time,
    String? petReport,
  }) {
    return CaseHistoryModel(
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      date: date ?? this.date,
      time: time ?? this.time,
      petReport: petReport ?? this.petReport,
    );
  }

  factory CaseHistoryModel.fromFirestore(
      String id, DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CaseHistoryModel(
      id: id,
      ownerName: snapshot['ownerName'],
      phone: snapshot['phone'],
      petName: snapshot['petName'],
      petType: snapshot['petType'],
      date: snapshot['date'],
      time: snapshot['time'],
      petReport: snapshot['petReport'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerName': ownerName,
      'phone': phone,
      'petName': petName,
      'petType': petType,
      'date': date,
      'time': time,
      'petReport': petReport,
    };
  }

  List<String> toList() {
    return [
      id ?? '',
      ownerName,
      phone,
      petName,
      date,
      petType,
      time,
      petReport,
    ];
  }
}
