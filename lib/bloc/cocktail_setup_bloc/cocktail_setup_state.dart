part of 'cocktail_setup_bloc.dart';

class CocktailSelectionState {
  final List<Section> sections; // Current sections (may be filtered)
  final List<Section> originalSections; // Original full sections for ID lookup
  final Map<String, List<String>>
      selectedItems; // Combined selections for UI compatibility
  final Map<String, List<String>> step1Selections; // Step 1 specific selections
  final Map<String, List<String>> step2Selections; // Step 2 specific selections
  final bool isLoading;
  final String? errorMessage;

  CocktailSelectionState({
    required this.sections,
    List<Section>? originalSections,
    required this.selectedItems,
    Map<String, List<String>>? step1Selections,
    Map<String, List<String>>? step2Selections,
    this.isLoading = false,
    this.errorMessage,
  })  : originalSections = originalSections ?? sections,
        step1Selections = step1Selections ?? {},
        step2Selections = step2Selections ?? {};

  CocktailSelectionState copyWith({
    List<Section>? sections,
    List<Section>? originalSections,
    Map<String, List<String>>? selectedItems,
    Map<String, List<String>>? step1Selections,
    Map<String, List<String>>? step2Selections,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CocktailSelectionState(
      sections: sections ?? this.sections,
      originalSections: originalSections ?? this.originalSections,
      selectedItems: selectedItems ?? this.selectedItems,
      step1Selections: step1Selections ?? this.step1Selections,
      step2Selections: step2Selections ?? this.step2Selections,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
