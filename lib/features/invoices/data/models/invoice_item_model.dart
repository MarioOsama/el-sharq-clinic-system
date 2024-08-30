class InvoiceItemModel {
  final String name;
  final double price;
  final int quantity;
  final String type;

  InvoiceItemModel(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.type});

  factory InvoiceItemModel.fromFirestore(Map<String, dynamic> data) {
    return InvoiceItemModel(
      name: data['name'],
      price: double.parse(data['price']),
      quantity: int.parse(data['quantity']),
      type: data['type'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'type': type,
    };
  }

  InvoiceItemModel copyWith({
    String? name,
    double? price,
    int? quantity,
    String? type,
  }) {
    return InvoiceItemModel(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
    );
  }
}
