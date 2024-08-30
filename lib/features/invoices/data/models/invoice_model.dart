import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/features/invoices/data/models/invoice_item_model.dart';

class InvoiceModel {
  final String id;
  final List<InvoiceItemModel> items;
  final int numberOfItems;
  final double total;
  final double discount;
  final String date;

  const InvoiceModel({
    required this.id,
    required this.items,
    required this.numberOfItems,
    required this.total,
    required this.discount,
    required this.date,
  });

  InvoiceModel copyWith({
    String? id,
    List<InvoiceItemModel>? items,
    int? numberOfItems,
    double? total,
    double? discount,
    String? date,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      items: items ?? this.items,
      numberOfItems: numberOfItems ?? this.numberOfItems,
      total: total ?? this.total,
      discount: discount ?? this.discount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((e) => e.toFirestore()).toList(),
      'numberOfItems': numberOfItems,
      'total': total,
      'discount': discount,
      'date': date,
    };
  }

  factory InvoiceModel.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InvoiceModel(
      id: doc.id,
      items: (data['items'] as List)
          .map((e) => InvoiceItemModel.fromFirestore(e))
          .toList(),
      numberOfItems: data['numberOfItems'],
      total: double.parse(data['total'].toString()),
      discount: double.parse(data['discount'].toString()),
      date: data['date'],
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> map = toMap();
    for (var key in map.keys.toList()) {
      if (map[key] == null ||
          map[key].toString().trim().isEmpty ||
          map[key] == 0 ||
          key == 'id') {
        map.remove(key);
      }
    }
    return map;
  }

  List<String> toList() {
    return [
      id,
      '$total LE',
      numberOfItems.toString(),
      date.substring(0, 10),
      date.substring(11, 19),
      discount.toString(),
      items.map((e) => e.name).toList().join('/n'),
    ];
  }
}
