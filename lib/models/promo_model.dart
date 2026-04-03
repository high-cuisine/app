class PromoItem {
  final int id;
  final String name;
  final String description;
  final int cost;
  final String links;
  final String? code;

  PromoItem({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.links,
    this.code,
  });

  factory PromoItem.fromJson(Map<String, dynamic> json) {
    return PromoItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      cost: json['cost'],
      links: json['links'] ?? '',
      code: json['code'],
    );
  }

  PromoItem copyWith({
    int? id,
    String? name,
    String? description,
    int? cost,
    String? links,
    String? code,
  }) {
    return PromoItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      links: links ?? this.links,
      code: code ?? this.code, // Если код не передан, оставляем текущий
    );
  }
}
