import 'package:bloc/bloc.dart';

import '../../models/ingredient_category_model.dart';
import '../../provider/cocktail_list_get.dart';

part 'cocktail_setup_event.dart';
part 'cocktail_setup_state.dart';

class CocktailSelectionBloc
    extends Bloc<CocktailSelectionEvent, CocktailSelectionState> {
  final CocktailRepository repository;

  CocktailSelectionBloc(this.repository)
      : super(CocktailSelectionState(
            sections: [], selectedItems: {}, originalSections: [])) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<LoadFilteredCategoriesEvent>(_loadFilteredCategories);
    on<ToggleSelectionEvent>(_toggleSelectionEvent);
    on<ClearSelectionEvent>(_clearSelectionEvent);
  }

  List<int> getSelectedIngredientIds() {
    final selectedIngredients = <int>[];

    state.selectedItems.forEach((category, items) {
      for (var item in items) {
        try {
          // Use originalSections for ID lookup to avoid issues with filtered data
          final categoryData = state.originalSections
              .expand((section) => section.categories)
              .firstWhere((cat) => cat.name == category,
                  orElse: () =>
                      throw StateError('Category not found: $category'));
          final ingredient = categoryData.ingredients.firstWhere(
              (ingredient) => ingredient.name == item,
              orElse: () => throw StateError('Ingredient not found: $item'));
          selectedIngredients.add(ingredient.id);
        } catch (e) {
          // Skip ingredients that are not found in original data
          print(
              'Warning: Could not find ingredient "$item" in category "$category" in original data: $e');
          continue;
        }
      }
    });

    return selectedIngredients;
  }

  /// Get ingredient IDs selected in Step 1 (base ingredients)
  List<int> getStep1IngredientIds() {
    final selectedIngredients = <int>[];

    state.step1Selections.forEach((category, items) {
      for (var item in items) {
        try {
          final categoryData = state.originalSections
              .expand((section) => section.categories)
              .firstWhere((cat) => cat.name == category,
                  orElse: () =>
                      throw StateError('Category not found: $category'));
          final ingredient = categoryData.ingredients.firstWhere(
              (ingredient) => ingredient.name == item,
              orElse: () => throw StateError('Ingredient not found: $item'));
          selectedIngredients.add(ingredient.id);
        } catch (e) {
          print(
              'Warning: Could not find Step 1 ingredient "$item" in category "$category": $e');
          continue;
        }
      }
    });

    return selectedIngredients;
  }

  /// Get ingredient IDs selected in Step 2 (additional ingredients)
  List<int> getStep2IngredientIds() {
    final selectedIngredients = <int>[];

    state.step2Selections.forEach((category, items) {
      for (var item in items) {
        try {
          final categoryData = state.originalSections
              .expand((section) => section.categories)
              .firstWhere((cat) => cat.name == category,
                  orElse: () =>
                      throw StateError('Category not found: $category'));
          final ingredient = categoryData.ingredients.firstWhere(
              (ingredient) => ingredient.name == item,
              orElse: () => throw StateError('Ingredient not found: $item'));
          selectedIngredients.add(ingredient.id);
        } catch (e) {
          print(
              'Warning: Could not find Step 2 ingredient "$item" in category "$category": $e');
          continue;
        }
      }
    });

    return selectedIngredients;
  }

  void _loadCategories(
      LoadCategoriesEvent event, Emitter<CocktailSelectionState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Грузим все секции/ингредиенты без серверного фильтра по withRecipesOnly,
      // разделение по алкогольным/безалкогольным делаем на клиенте.
      final sections = await repository.fetchSections();
      // Save as both sections and originalSections for full data access
      emit(state.copyWith(
          sections: sections, originalSections: sections, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void _loadFilteredCategories(LoadFilteredCategoriesEvent event,
      Emitter<CocktailSelectionState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final sections =
          await repository.fetchFilteredSections(event.selectedIngredientIds);
      // Update only sections, keep originalSections unchanged for ID lookup
      emit(state.copyWith(sections: sections, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void _toggleSelectionEvent(
      ToggleSelectionEvent event, Emitter<CocktailSelectionState> emit) async {
    // Get current selections for this category from the appropriate step
    final currentStepSelection = event.isStep1
        ? (state.step1Selections[event.category] ?? [])
        : (state.step2Selections[event.category] ?? []);

    // Get current combined selection for UI consistency
    final currentCombinedSelection = state.selectedItems[event.category] ?? [];

    // Create new lists for updates
    final updatedStepSelection = List<String>.from(currentStepSelection);
    final updatedCombinedSelection =
        List<String>.from(currentCombinedSelection);

    // Toggle the item in both step-specific and combined selections
    if (updatedStepSelection.contains(event.item)) {
      // Remove from step-specific selection
      updatedStepSelection.remove(event.item);
      // Remove from combined selection
      updatedCombinedSelection.remove(event.item);
    } else {
      // Add to step-specific selection
      updatedStepSelection.add(event.item);
      // Add to combined selection if not already present
      if (!updatedCombinedSelection.contains(event.item)) {
        updatedCombinedSelection.add(event.item);
      }
    }

    // Update only if something changed
    if (updatedStepSelection.length != currentStepSelection.length) {
      // Update the appropriate step-specific map
      final updatedStep1Selections =
          Map<String, List<String>>.from(state.step1Selections);
      final updatedStep2Selections =
          Map<String, List<String>>.from(state.step2Selections);
      final updatedCombinedItems =
          Map<String, List<String>>.from(state.selectedItems);

      if (event.isStep1) {
        updatedStep1Selections[event.category] = updatedStepSelection;
      } else {
        updatedStep2Selections[event.category] = updatedStepSelection;
      }

      updatedCombinedItems[event.category] = updatedCombinedSelection;

      // Emit new state with all updated maps
      emit(state.copyWith(
        step1Selections: updatedStep1Selections,
        step2Selections: updatedStep2Selections,
        selectedItems: updatedCombinedItems,
      ));
    }
  }

  void _clearSelectionEvent(
      ClearSelectionEvent event, Emitter<CocktailSelectionState> emit) async {
    emit(state.copyWith(selectedItems: {event.category: []}));
  }
}
