import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';

class ServiceModel extends SelableItemModel {
  final String icon;

  const ServiceModel({
    required super.id,
    required super.title,
    required super.price,
    super.description,
    required this.icon,
  });

  factory ServiceModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      title: data['title'],
      price: data['price'],
      icon: data['icon'],
      description: data['description'] ?? '',
    );
  }

  @override
  List<String> toList() {
    return super.toList() + [icon];
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll({'icon': icon});
  }
}
