class Product {
  final int id;
  final String? name;
  final String? description;
  final String? photo;
  final String? link;
  final String? price;

  Product({
    required this.id,
    this.price,
    this.name,
    this.description,
    this.photo,
    this.link,
  });

  // Фабричный метод для создания экземпляра из JSON-данных
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      // id обязательно
      price: json['price'],
      name: json['name'],
      // может быть null
      description: json['description'],
      // может быть null
      photo: json['photo'],
      // может быть null
      link: json['link'], // может быть null
    );
  }
}
