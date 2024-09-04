class InvoiceItemModel {
  final String name;
  final double price;
  final double quantity;
  final String type;

  InvoiceItemModel(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.type});

  factory InvoiceItemModel.fromMap(Map<String, dynamic> data) {
    return InvoiceItemModel(
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
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
    double? quantity,
    String? type,
  }) {
    return InvoiceItemModel(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'InvoiceItemModel(name: $name, price: $price, quantity: $quantity, type: $type)';
  }
}
