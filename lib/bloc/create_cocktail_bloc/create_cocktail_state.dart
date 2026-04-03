part of 'create_cocktail_bloc.dart';

class CocktailCreationState {
  final List<Section> sections; // Секции с категориями и ингредиентами
  final Map<int, Map<String, List<IngredientItem>>> selectedItems;
  final List<IngredientItem>
      ingredientItems; // Ингредиенты с количеством и типом
  final List<Tool> tools; // Инструменты
  final List<Tool> selectedTools; // Выбранные инструменты
  final List<RecipeStep> steps;
  final File? photo;
  final String title;
  final String description;
  final File? videoFile;
  final String? videoAwsKey;
  final String videoUrl;
  final bool isLoading;
  final bool isSubmitting;
  final bool submissionSuccess;
  final String? submissionError;
  final String? errorMessage;
  final File? videoThumbnailFile;

  const CocktailCreationState(
      {required this.sections,
      required this.selectedItems,
      required this.ingredientItems,
      required this.tools,
      required this.selectedTools,
      required this.steps,
      this.title = '',
      this.description = '',
      this.videoFile,
      this.videoAwsKey,
      this.videoUrl = '',
      this.photo,
      this.isLoading = false,
      this.isSubmitting = false,
      this.submissionSuccess = false,
      this.submissionError,
      this.errorMessage,
      this.videoThumbnailFile});

  CocktailCreationState copyWith({
    List<Section>? sections,
    Map<int, Map<String, List<IngredientItem>>>? selectedItems,
    List<IngredientItem>? ingredientItems,
    List<Tool>? tools,
    List<Tool>? selectedTools,
    List<RecipeStep>? steps,
    File? photo,
    String? title,
    String? description,
    File? videoFile,
    String? videoAwsKey,
    String? videoUrl,
    bool? isLoading,
    bool? isSubmitting,
    bool? submissionSuccess,
    String? submissionError,
    String? errorMessage,
    File? videoThumbnailFile,
  }) {
    return CocktailCreationState(
      sections: sections ?? this.sections,
      selectedItems: selectedItems ?? this.selectedItems,
      ingredientItems: ingredientItems ?? this.ingredientItems,
      tools: tools ?? this.tools,
      selectedTools: selectedTools ?? this.selectedTools,
      steps: steps ?? this.steps,
      photo: photo ?? this.photo,
      title: title ?? this.title,
      description: description ?? this.description,
      videoFile: videoFile ?? this.videoFile,
      videoAwsKey: videoAwsKey ?? this.videoAwsKey,
      videoUrl: videoFile != null ? '' : videoUrl ?? this.videoUrl,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      submissionError: submissionError,
      errorMessage: errorMessage ?? this.errorMessage,
      videoThumbnailFile: videoThumbnailFile ?? this.videoThumbnailFile,
    );
  }
}
