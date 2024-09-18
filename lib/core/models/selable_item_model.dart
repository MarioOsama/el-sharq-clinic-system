abstract class SelableItemModel {
  final String id;
  final String title;
  final double price;
  final String? description;

  const SelableItemModel({
    required this.id,
    required this.title,
    required this.price,
    this.description,
  });

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> map = toMap();
    for (var key in map.keys.toList()) {
      if (map[key] == null ||
          map[key].toString().trim().isEmpty ||
          key == 'id') {
        map.remove(key);
      }
    }
    return map;
  }

  List<String> toList() {
    return [id, title, price.toString(), description ?? ''];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description
    };
  }
}
