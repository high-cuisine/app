part of 'catalog_filter_bloc.dart';

@immutable
abstract class IngredientSelectionEvent {}

class ToggleSelectionEvent extends IngredientSelectionEvent {
  final int sectionId; // Добавляем sectionId
  final String category;
  final String item;

  ToggleSelectionEvent(this.sectionId, this.category, this.item);
}

class ClearSelectionEvent extends IngredientSelectionEvent {
  final int sectionId; // Добавляем sectionId
  final String category;

  ClearSelectionEvent(this.sectionId, this.category);
}

class LoadCategoriesEvent extends IngredientSelectionEvent {}
