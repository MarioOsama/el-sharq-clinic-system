import 'package:cloud_firestore/cloud_firestore.dart';

class CaseHistoryModel {
  final String id;
  final String ownerName;
  final String? phone;
  final String? petName;
  final String? petType;
  final String date;
  final String? time;
  final String petReport;

  CaseHistoryModel({
    required this.id,
    required this.ownerName,
    this.phone,
    this.petName,
    this.petType,
    required this.date,
    this.time,
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

  factory CaseHistoryModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CaseHistoryModel(
      id: doc.id,
      ownerName: data['ownerName'],
      phone: data['phone'],
      petName: data['petName'],
      petType: data['petType'],
      date: data['date'] ?? '',
      time: data['time'],
      petReport: data['petReport'] ?? '',
    );
  }

  /// Create a map with the only non-null values
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> map = toMap();
    for (var key in map.keys.toList()) {
      if (map[key].toString().trim().isEmpty || map[key] == null) {
        map.remove(key);
      }
    }
    return map;
  }

  List<String> toList() {
    return [
      id,
      ownerName,
      phone ?? '',
      petName ?? '',
      date,
      petType ?? '',
      time ?? '',
      petReport,
    ];
  }

  Map<String, String?> toMap() {
    return {
      'id': id,
      'ownerName': ownerName,
      'phone': phone,
      'petName': petName,
      'date': date,
      'petType': petType,
      'time': time,
      'petReport': petReport,
    };
  }
}
