import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';

enum ProductType { medicines, accessories }

class ProductModel extends SelableItemModel {
  final double quantity;
  final ProductType type;

  ProductModel({
    required super.id,
    required super.price,
    required super.title,
    required this.quantity,
    required this.type,
    super.description,
  });

  factory ProductModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    final product = ProductModel(
      id: doc.id,
      price: double.parse(data['price'].toString()),
      title: data['title'],
      quantity: double.parse(data['quantity'].toString()),
      type: ProductType.values.firstWhere(
        (e) => e.toString() == 'ProductType.${data['type']}',
      ),
      description: data['description'] ?? '',
    );
    return product;
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
      type: type,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'quantity': quantity,
        'type': type.toString().split('.').last,
      });
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, price: $price, title: $title, description: $description, quantity: $quantity, type: $type)';
  }
}
