import 'ingredient_category_model.dart';

class IngredientItem {
  final Ingredients ingredient;
  final String quantity;
  final String type;
  final int sectionId; // Добавляем секцию
  final String category; // Добавляем категорию

  IngredientItem({
    required this.ingredient,
    required this.quantity,
    required this.type,
    required this.sectionId, // Инициализируем секцию
    required this.category, // Инициализируем категорию
  });

  // Копия с обновленным количеством, типом, секцией и категорией
  IngredientItem copyWith({
    String? quantity,
    String? type,
    int? sectionId,
    String? category,
  }) {
    return IngredientItem(
      ingredient: ingredient,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      sectionId: sectionId ?? this.sectionId,
      category: category ?? this.category,
    );
  }

  // Для отправки данных в формате JSON
  Map<String, dynamic> toJson() {
    return {
      "ingredient": ingredient.id,
      "quantity": quantity,
      "type": type,
      "sectionId": sectionId,
      "category": category,
    };
  }
}

class RecipeStep {
  final int number;
  final String description;

  RecipeStep({required this.number, required this.description});
}
