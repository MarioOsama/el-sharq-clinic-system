import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/models/selable_item_model.dart';

class ProductModel extends SelableItemModel {
  ProductModel({
    required super.id,
    required super.price,
    required super.title,
    super.description,
  });

  factory ProductModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      price: data['price'],
      title: data['title'],
      description: data['description'] ?? '',
    );
  }
}
