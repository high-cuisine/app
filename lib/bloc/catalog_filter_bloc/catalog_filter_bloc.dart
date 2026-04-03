import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/ingredient_category_model.dart';
import '../../provider/cocktail_list_get.dart';

part 'catalog_filter_event.dart';
part 'catalog_filter_state.dart';

class IngredientSelectionBloc
    extends Bloc<IngredientSelectionEvent, IngredientSelectionState> {
  final CocktailRepository repository;

  IngredientSelectionBloc(this.repository)
      : super(const IngredientSelectionState(sections: [], selectedItems: {})) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<ToggleSelectionEvent>(_toggleSelectionEvent);
    on<ClearSelectionEvent>(_clearSelectionEvent);
  }

  List<int> getSelectedIngredientIds() {
    final selectedIngredients = <int>[];

    // Проходим по секциям и категориям, чтобы найти выбранные ингредиенты
    state.selectedItems.forEach((sectionId, categories) {
      categories.forEach((category, items) {
        for (var item in items) {
          final categoryData = state.sections
              .expand((section) => section.categories)
              .firstWhere((cat) => cat.name == category);
          final ingredient = categoryData.ingredients
              .firstWhere((ingredient) => ingredient.name == item);
          selectedIngredients.add(ingredient.id);
        }
      });
    });

    return selectedIngredients;
  }

  // Загружаем категории
  void _loadCategories(
      LoadCategoriesEvent event, Emitter<IngredientSelectionState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Для фильтров в каталоге нужно показывать все ингредиенты,
      // а не только те, у которых уже есть рецепты.
      final sections =
          await repository.fetchSections(withRecipesOnly: false);
      emit(state.copyWith(sections: sections, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  // Обрабатываем выбор ингредиента
  void _toggleSelectionEvent(ToggleSelectionEvent event,
      Emitter<IngredientSelectionState> emit) async {
    // Получаем текущие выбранные ингредиенты для категории
    final currentSelection =
        state.selectedItems[event.sectionId]?[event.category] ?? [];
    final updatedSelection = List<Ingredients>.from(currentSelection);

    // В UI `sectionId` используется как "шаг" (1/2), а не реальный id секции API.
    // Поэтому категорию/ингредиент ищем по всем секциям, иначе firstWhere падает,
    // и в интерфейсе кажется, что "клики не работают".
    final Category category;
    try {
      category = state.sections
          .expand((section) => section.categories)
          .firstWhere((cat) => cat.name == event.category);
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Category not found: ${event.category}'));
      return;
    }

    final Ingredients ingredient;
    try {
      ingredient = category.ingredients.firstWhere((ing) => ing.name == event.item);
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Ingredient not found: ${event.item}'));
      return;
    }

    if (updatedSelection.contains(ingredient)) {
      updatedSelection.remove(ingredient);
    } else {
      updatedSelection.add(ingredient);
    }

    if (updatedSelection.length != currentSelection.length) {
      final updatedItems =
          Map<int, Map<String, List<Ingredients>>>.from(state.selectedItems);
      updatedItems[event.sectionId] = {
        ...updatedItems[event.sectionId] ?? {},
        event.category: updatedSelection,
      };

      emit(state.copyWith(selectedItems: updatedItems, errorMessage: null));
    }
  }

  // Очищаем выбранные элементы в определенной секции и категории
  void _clearSelectionEvent(
      ClearSelectionEvent event, Emitter<IngredientSelectionState> emit) async {
    final updatedItems =
        Map<int, Map<String, List<Ingredients>>>.from(state.selectedItems);
    updatedItems[event.sectionId] = {
      ...updatedItems[event.sectionId] ?? {},
    };

    // Очищаем выбранные ингредиенты для конкретной секции и категории
    updatedItems[event.sectionId]?.remove(event.category);

    emit(state.copyWith(selectedItems: updatedItems));
  }
}
