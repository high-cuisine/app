part of 'create_cocktail_bloc.dart';

@immutable
abstract class CocktailCreationEvent {}

class LoadCategoriesEvent extends CocktailCreationEvent {}

class AddIngredientEvent extends CocktailCreationEvent {
  final IngredientItem ingredientItem; // Изменили на IngredientItem

  AddIngredientEvent(this.ingredientItem);
}

class RemoveIngredientEvent extends CocktailCreationEvent {
  final IngredientItem ingredientItem; // Изменили на IngredientItem

  RemoveIngredientEvent(this.ingredientItem);
}

class UpdateIngredientQuantityEvent extends CocktailCreationEvent {
  final IngredientItem ingredientItem;
  final String newQuantity;

  UpdateIngredientQuantityEvent(this.ingredientItem, this.newQuantity);
}

class UpdateIngredientTypeEvent extends CocktailCreationEvent {
  final IngredientItem ingredientItem;
  final String newType;

  UpdateIngredientTypeEvent(this.ingredientItem, this.newType);
}

class LoadToolsEvent extends CocktailCreationEvent {}

class AddToolEvent extends CocktailCreationEvent {
  final Tool tool;

  AddToolEvent(this.tool);
}

class RemoveToolEvent extends CocktailCreationEvent {
  final Tool tool;

  RemoveToolEvent(this.tool);
}

class AddStepEvent extends CocktailCreationEvent {
  final RecipeStep step;

  AddStepEvent(this.step);
}

class UpdateStepEvent extends CocktailCreationEvent {
  final RecipeStep step;

  UpdateStepEvent(this.step);
}

class RemoveStepEvent extends CocktailCreationEvent {
  final int stepNumber;

  RemoveStepEvent(this.stepNumber);
}

class UpdatePhotoEvent extends CocktailCreationEvent {
  final File photo;

  UpdatePhotoEvent(this.photo);
}

class UpdateRecipeTitleEvent extends CocktailCreationEvent {
  final String title;

  UpdateRecipeTitleEvent(this.title);
}

class UpdateRecipeDescriptionEvent extends CocktailCreationEvent {
  final String description;

  UpdateRecipeDescriptionEvent(this.description);
}

class UpdateRecipeVideoUrlEvent extends CocktailCreationEvent {
  final String videoUrl;

  UpdateRecipeVideoUrlEvent(this.videoUrl);
}

class UpdateVideoThumbnailEvent extends CocktailCreationEvent {
  final File thumbnailFile;

  UpdateVideoThumbnailEvent(this.thumbnailFile);
}

class UpdateRecipeVideoFileEvent extends CocktailCreationEvent {
  final File file;

  UpdateRecipeVideoFileEvent(this.file);
}

class UpdateRecipeVideoAwsKeyEvent extends CocktailCreationEvent {
  final String awsKey;

  UpdateRecipeVideoAwsKeyEvent(this.awsKey);
}

class UploadVideoToS3Event extends CocktailCreationEvent {
  final File videoFile;

  UploadVideoToS3Event(this.videoFile);
}

class ResetCreationEvent extends CocktailCreationEvent {}

class ResetSubmissionSuccessEvent extends CocktailCreationEvent {}

class SubmitRecipeEvent extends CocktailCreationEvent {}
