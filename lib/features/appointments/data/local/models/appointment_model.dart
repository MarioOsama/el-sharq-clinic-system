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

  factory AppointmentModel.fromFirestore(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      ownerName: json['ownerName'],
      phone: json['phone'],
      petName: json['petName'],
      petType: json['petType'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      petCondition: json['petCondition'],
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
