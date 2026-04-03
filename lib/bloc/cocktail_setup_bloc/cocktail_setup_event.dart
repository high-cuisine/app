part of 'cocktail_setup_bloc.dart';

abstract class CocktailSelectionEvent {}

class ToggleSelectionEvent extends CocktailSelectionEvent {
  final String category;
  final String item;
  final bool isStep1; // true for Step 1, false for Step 2

  ToggleSelectionEvent(this.category, this.item, this.isStep1);
}

class ClearSelectionEvent extends CocktailSelectionEvent {
  final String category;

  ClearSelectionEvent(this.category);
}

class LoadCategoriesEvent extends CocktailSelectionEvent {}

class LoadFilteredCategoriesEvent extends CocktailSelectionEvent {
  final List<int> selectedIngredientIds;

  LoadFilteredCategoriesEvent(this.selectedIngredientIds);
}
