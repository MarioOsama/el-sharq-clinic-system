class InvoiceItemModel {
  final String name;
  final double price;
  final double quantity;
  final double discountPercentage;
  final String type;

  InvoiceItemModel(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.discountPercentage,
      required this.type});

  factory InvoiceItemModel.fromMap(Map<String, dynamic> data) {
    return InvoiceItemModel(
      name: data['name'],
      price: data['price'],
      quantity: data['quantity'],
      discountPercentage: data['discountPercentage'],
      type: data['type'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'discountPercentage': discountPercentage,
      'type': type,
    };
  }

  InvoiceItemModel copyWith({
    String? name,
    double? price,
    double? quantity,
    double? discountPercentage,
    String? type,
  }) {
    return InvoiceItemModel(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      type: type ?? this.type,
    );
  }

  double get getTotal => price * quantity;

  double get getTotalAfterDiscount =>
      getTotal - (discountPercentage / 100) * getTotal;

  @override
  String toString() {
    return 'InvoiceItemModel(name: $name, price: $price, quantity: $quantity, type: $type)';
  }
}
