part of 'catalog_filter_bloc.dart';

@immutable
class IngredientSelectionState {
  final List<Section> sections;
  final Map<int, Map<String, List<Ingredients>>>
      selectedItems; // Изменяем на List<Ingredients>
  final bool isLoading;
  final String? errorMessage;

  const IngredientSelectionState({
    required this.sections,
    required this.selectedItems,
    this.isLoading = false,
    this.errorMessage,
  });

  IngredientSelectionState copyWith({
    List<Section>? sections,
    Map<int, Map<String, List<Ingredients>>>? selectedItems, // Обновляем тип
    bool? isLoading,
    String? errorMessage,
  }) {
    return IngredientSelectionState(
      sections: sections ?? this.sections,
      selectedItems: selectedItems ?? this.selectedItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
