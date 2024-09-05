import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';

class ProductModel extends SelableItemModel {
  final double quantity;

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
      quantity: double.parse(data['quantity'].toString()),
      description: data['description'] ?? '',
    );
  }

  ProductModel copyWith({
    String? id,
    double? price,
    String? title,
    String? description,
    double? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      price: price ?? this.price,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'quantity': quantity,
      });
  }
}
