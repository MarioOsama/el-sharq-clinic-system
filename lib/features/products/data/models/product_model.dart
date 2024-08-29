import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';

class ProductModel extends SelableItemModel {
  final int quantity;

  ProductModel({
    required super.id,
    required super.price,
    required super.title,
    required this.quantity,
    super.description,
  });

  factory ProductModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      price: double.parse(data['price'].toString()),
      title: data['title'],
      quantity: data['quantity'],
      description: data['description'] ?? '',
    );
  }

  ProductModel copyWith({
    String? id,
    double? price,
    String? title,
    String? description,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      price: price ?? this.price,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
    );
  }
}
