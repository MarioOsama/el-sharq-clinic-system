import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
  final String id;
  final String ownerId;
  final String name;
  final String? type;
  final String? breed;
  final String? gender;
  final String? vaccinations;
  final String? treatments;
  final String petReport;
  final String? color;
  final double? age;
  final double? weight;

  PetModel(
      {required this.id,
      required this.ownerId,
      required this.name,
      this.type,
      this.breed,
      this.gender,
      this.vaccinations,
      this.treatments,
      required this.petReport,
      this.color,
      this.age,
      this.weight});

  PetModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? type,
    String? breed,
    String? gender,
    String? vaccinations,
    String? treatments,
    String? petReport,
    String? color,
    double? age,
    double? weight,
  }) {
    return PetModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      vaccinations: vaccinations ?? this.vaccinations,
      treatments: treatments ?? this.treatments,
      petReport: petReport ?? this.petReport,
      color: color ?? this.color,
      age: age ?? this.age,
      weight: weight ?? this.weight,
    );
  }

  factory PetModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PetModel(
      id: doc.id,
      ownerId: data['ownerId'],
      name: data['name'],
      type: data['type'],
      breed: data['breed'],
      gender: data['gender'],
      vaccinations: data['vaccinations'],
      treatments: data['treatments'],
      petReport: data['petReport'],
      color: data['color'],
      age: data['age'],
      weight: data['weight'],
    );
  }

  /// Create a map with the only non-null values
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> map = toMap();
    for (var key in map.keys.toList()) {
      if (map[key].toString().trim().isEmpty ||
          map[key] == null ||
          map[key] == 0) {
        map.remove(key);
      }
    }
    return map;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'gender': gender,
      'vaccinations': vaccinations,
      'treatments': treatments,
      'petReport': petReport,
      'color': color,
      'age': age,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return 'PetModel(id: $id, ownerId: $ownerId, name: $name, type: $type, breed: $breed, gender: $gender, vaccinations: $vaccinations, treatments: $treatments, petReport: $petReport, color: $color, age: $age, weight: $weight)';
  }
}
