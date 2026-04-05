// Cocktail cocktailFromJson(String str) => Cocktail.fromJson(json.decode(str));
//
// String cocktailToJson(Cocktail data) => json.encode(data.toJson());
class CocktailResponseModel {
  final int count;
  final List<Cocktail> cocktails;

  CocktailResponseModel({required this.count, required this.cocktails});
}

class Cocktail {
  int id;
  int ingredientCount;
  List<Ingredient> ingredients;
  List<Tool> tools;
  bool isFavorite;
  String? imageUrl;
  String name;
  String description;
  Map<String, String>? instruction;
  bool isEnabled;
  String? photo;
  bool claimed;
  String moderationStatus;
  String? videoUrl;
  int user;
  bool isImageAvailable;
  String? video_aws_key;
  String? videoFileUrl;

  Cocktail({
    required this.id,
    required this.ingredientCount,
    required this.ingredients,
    required this.tools,
    required this.isFavorite,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.instruction,
    required this.isEnabled,
    required this.photo,
    required this.claimed,
    required this.moderationStatus,
    required this.videoUrl,
    required this.user,
    required this.video_aws_key,
    this.videoFileUrl,
    this.isImageAvailable = true,
  });

  Cocktail copyWith({
    int? id,
    int? ingredientCount,
    List<Ingredient>? ingredients,
    List<Tool>? tools,
    bool? isFavorite,
    String? imageUrl,
    String? name,
    String? description,
    Map<String, String>? instruction,
    bool? isEnabled,
    String? photo,
    bool? claimed,
    String? moderationStatus,
    String? videoUrl,
    int? user,
    String? video_aws_key,
    String? videoFileUrl,
  }) {
    return Cocktail(
      id: id ?? this.id,
      ingredientCount: ingredientCount ?? this.ingredientCount,
      ingredients: ingredients ?? this.ingredients,
      tools: tools ?? this.tools,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      description: description ?? this.description,
      instruction: instruction ?? this.instruction,
      isEnabled: isEnabled ?? this.isEnabled,
      photo: photo ?? this.photo,
      claimed: claimed ?? this.claimed,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      videoUrl: videoUrl ?? this.videoUrl,
      user: user ?? this.user,
      video_aws_key: video_aws_key ?? this.video_aws_key,
      videoFileUrl: videoFileUrl ?? this.videoFileUrl,
    );
  }

  /// Бэкенд отдаёт `instruction` то как `{"Step 1": "..."}`, то как список шагов.
  static Map<String, String>? _instructionFromJson(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map) {
      return raw.map(
        (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
      );
    }
    if (raw is List) {
      final out = <String, String>{};
      for (var i = 0; i < raw.length; i++) {
        final item = raw[i];
        if (item is Map) {
          final step = item['step']?.toString() ?? 'Step ${i + 1}';
          final desc = item['description']?.toString() ?? '';
          out[step] = desc;
        } else {
          out['Step ${i + 1}'] = item?.toString() ?? '';
        }
      }
      return out.isEmpty ? null : out;
    }
    return null;
  }

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json["id"],
      ingredientCount: json["ingredient_count"] ?? 0,
      ingredients: (json["ingredients"] as List<dynamic>?)
              ?.map((item) => Ingredient.fromJson(item))
              .toList() ??
          [],
      tools: (json["tools"] as List<dynamic>?)
              ?.map((item) => Tool.fromJson(item))
              .toList() ??
          [],
      isFavorite: json["is_favorite"] ?? false,
      imageUrl: (() {
        final photo = json["photo"] as String?;
        if (photo != null && photo.isNotEmpty) return photo;
        final photoUrl = json["photo_url"] as String?;
        if (photoUrl != null && photoUrl.isNotEmpty) return photoUrl;
        return json["image"] as String?;
      })(),
      name: json["title"] ?? '',
      description: json["description"] ?? '',
      instruction: _instructionFromJson(json["instruction"]),
      isEnabled: json["isEnabled"] ?? true,
      photo: json["photo"] as String?,
      claimed: json["claimed"] ?? false,
      moderationStatus: json["moderation_status"] ?? '',
      videoUrl: () {
        final v = json["video_url"];
        if (v == null) return null;
        if (v is String) return v.isEmpty ? null : v;
        return v.toString();
      }(),
      user: json["user"],
      video_aws_key: json["video_aws_key"] as String?,
      videoFileUrl: json["video_file_url"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "ingredient_count": ingredientCount,
        "ingredients": ingredients.map((x) => x.toJson()).toList(),
        "tools": tools.map((x) => x.toJson()).toList(),
        "is_favorite": isFavorite,
        "image": imageUrl,
        "photo_url": imageUrl,
        "title": name,
        "description": description,
        "instruction": instruction,
        "isEnabled": isEnabled,
        "photo": photo,
        "claimed": claimed,
        "moderation_status": moderationStatus,
        "video_url": videoUrl,
        "user": user,
        "video_aws_key": video_aws_key,
        "video_file_url": videoFileUrl,
      };
}

class Ingredient {
  int ingredientId;
  String name;
  String quantity;
  String type;

  // Карта переводов единиц измерения
  static const Map<String, String> unitsTranslation = {
    'ounce': 'унция',
    'ml': 'мл',
    'gram': 'грамм',
    'piece': 'шт',
    'spoon': 'ложка',
    'cup': 'кружка',
    'tablespoon': 'столовая ложка',
    'teaspoon': 'чайная ложка',
    'slice': 'ломтик',
    'twist': 'твист',
    'cube': 'кубик',
    'sprig': 'веточка',
    'pinch': 'щепотка',
    'spiral': 'спираль',
    'wedge': 'долька',
    'dash': 'дэш',
    'block': 'блок',
    'circle': 'кружок',
    'bottle': 'бутылка',
  };

  Ingredient({
    required this.ingredientId,
    required this.name,
    required this.quantity,
    required this.type,
  });

  // Метод для получения переведённой единицы измерения
  String getTranslatedType(String currentLanguage) {
    if (currentLanguage == 'rus') {
      return unitsTranslation[type] ?? type;
    }
    return type;
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredientId: json["ingredient"] ?? 0,
      name: json["name"] ?? '',
      quantity: json["quantity"] ?? '',
      type: json["type"] ?? '',
    );
  }

  // Метод toJson для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      "ingredient": ingredientId,
      "name": name,
      "quantity": quantity,
      "type": type,
    };
  }

  @override
  String toString() {
    return '$name: $quantity ${unitsTranslation[type] ?? type}';
  }
}

class Tool {
  int id;
  String name;
  String? description;
  String? history;
  String? howToUse;
  String? photo;
  List<dynamic>? links;

  Tool({
    required this.id,
    required this.name,
    this.description,
    this.history,
    this.howToUse,
    this.photo,
    this.links,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      id: json["id"],
      name: json["name"] ?? 'Unknown Tool',
      description: json["description"] ?? '',
      history: json["history"] ?? '',
      howToUse: json["how_to_use"] ?? '',
      photo: json["photo"] ?? '',
      links: json["links"] != null ? List<dynamic>.from(json["links"]) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "history": history,
        "how_to_use": howToUse,
        "photo": photo,
        "links": links?.map((x) => x).toList(),
      };
}
