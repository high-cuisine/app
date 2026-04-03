import 'dart:convert';
import 'dart:io';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../../models/cocktail_list_model.dart';
import '../../models/create_cocktail_model.dart';
import '../../models/ingredient_category_model.dart';
import '../../provider/cocktail_list_get.dart';
import '../../provider/profile_repository.dart';

part 'create_cocktail_event.dart';
part 'create_cocktail_state.dart';

class CocktailCreationBloc
    extends Bloc<CocktailCreationEvent, CocktailCreationState> {
  final CocktailRepository repository;

  CocktailCreationBloc(this.repository)
      : super(const CocktailCreationState(
          sections: [],
          selectedItems: {},
          ingredientItems: [],
          tools: [],
          selectedTools: [],
          steps: [],
        )) {
    on<LoadCategoriesEvent>(_loadCategories);
    on<AddIngredientEvent>(_addIngredient);
    on<RemoveIngredientEvent>(_removeIngredient);
    on<UpdateIngredientQuantityEvent>(_updateIngredientQuantity);
    on<UpdateIngredientTypeEvent>(_updateIngredientType);
    on<LoadToolsEvent>(_loadTools);
    on<AddToolEvent>(_addTool);
    on<RemoveToolEvent>(_removeTool);
    on<AddStepEvent>(_onAddStep);
    on<UpdateStepEvent>(_onUpdateStep);
    on<RemoveStepEvent>(_onRemoveStep);
    on<UpdatePhotoEvent>(_onUpdatePhoto);
    on<UpdateRecipeTitleEvent>(_onUpdateRecipeTitle);
    on<UpdateRecipeDescriptionEvent>(_onUpdateRecipeDescription);
    on<UpdateRecipeVideoUrlEvent>(_onUpdateRecipeVideoUrl);
    on<UpdateRecipeVideoFileEvent>(_onUpdateVideoFile);
    on<UpdateRecipeVideoAwsKeyEvent>(_onUpdateVideoAwsKey);
    on<SubmitRecipeEvent>(_onSubmitRecipe);
    on<UploadVideoToS3Event>(_onUploadVideoToS3);
    on<ResetSubmissionSuccessEvent>((e, emit) {
      emit(state.copyWith(submissionSuccess: false));
    });
    on<ResetCreationEvent>((e, emit) {
      emit(const CocktailCreationState(
        sections: [],
        selectedItems: {},
        ingredientItems: [],
        tools: [],
        selectedTools: [],
        steps: [],
        // обнуляем всё, что храним
        photo: null,
        videoFile: null,
        videoThumbnailFile: null,
        videoAwsKey: null,
        videoUrl: '',
        title: '',
        description: '',
        isLoading: false,
        errorMessage: null,
      ));
    });
    on<UpdateVideoThumbnailEvent>((e, emit) {
      emit(state.copyWith(videoThumbnailFile: e.thumbnailFile));
    });
  }

  // Загрузка категорий и секций
  void _loadCategories(
      LoadCategoriesEvent event, Emitter<CocktailCreationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      print('Loading categories...');
      final sections = await repository.fetchSections();
      print('Loaded sections: $sections');
      emit(state.copyWith(sections: sections, isLoading: false));
    } catch (e) {
      print('Error loading categories: $e');
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  // Добавляем ингредиент как IngredientItem с секцией и категорией
  void _addIngredient(
    AddIngredientEvent event,
    Emitter<CocktailCreationState> emit,
  ) {
    print(
        'Adding ingredient to general list: ${event.ingredientItem.ingredient.name}');

    // Обновляем список ингредиентов
    final updatedIngredients = List<IngredientItem>.from(state.ingredientItems)
      ..add(event.ingredientItem);
    print('Updated ingredientItems: $updatedIngredients');

    // Обновляем selectedItems по секциям и категориям
    final currentSelection = state.selectedItems[event.ingredientItem.sectionId]
            ?[event.ingredientItem.category] ??
        [];
    final updatedSelection = List<IngredientItem>.from(currentSelection)
      ..add(event.ingredientItem);

    final updatedItems =
        Map<int, Map<String, List<IngredientItem>>>.from(state.selectedItems);
    updatedItems[event.ingredientItem.sectionId] = {
      ...updatedItems[event.ingredientItem.sectionId] ?? {},
      event.ingredientItem.category: updatedSelection,
    };

    print(
        'Updated selection for section ${event.ingredientItem.sectionId}, category ${event.ingredientItem.category}: ${updatedItems[event.ingredientItem.sectionId]}');

    emit(state.copyWith(
      ingredientItems: updatedIngredients,
      selectedItems: updatedItems,
    ));
  }

  // Удаляем ингредиент
  void _removeIngredient(
      RemoveIngredientEvent event, Emitter<CocktailCreationState> emit) {
    print('Removing ingredient: ${event.ingredientItem.ingredient.name}');

    // Обновляем список ингредиентов
    final updatedIngredients = List<IngredientItem>.from(state.ingredientItems)
      ..remove(event.ingredientItem);

    // Обновляем selectedItems по секциям и категориям
    final currentSelection = state.selectedItems[event.ingredientItem.sectionId]
            ?[event.ingredientItem.category] ??
        [];
    final updatedSelection = List<IngredientItem>.from(currentSelection)
      ..remove(event.ingredientItem);

    final updatedItems =
        Map<int, Map<String, List<IngredientItem>>>.from(state.selectedItems);
    updatedItems[event.ingredientItem.sectionId] = {
      ...updatedItems[event.ingredientItem.sectionId] ?? {},
      event.ingredientItem.category: updatedSelection,
    };

    emit(state.copyWith(
      ingredientItems: updatedIngredients,
      selectedItems: updatedItems,
    ));
  }

  // Обновляем количество ингредиента
  void _updateIngredientQuantity(UpdateIngredientQuantityEvent event,
      Emitter<CocktailCreationState> emit) {
    final updatedIngredients = state.ingredientItems.map((ingredientItem) {
      return ingredientItem == event.ingredientItem
          ? ingredientItem.copyWith(quantity: event.newQuantity)
          : ingredientItem;
    }).toList();
    emit(state.copyWith(ingredientItems: updatedIngredients));
  }

  // Обновляем тип ингредиента (ml, g и т.д.)
  void _updateIngredientType(
      UpdateIngredientTypeEvent event, Emitter<CocktailCreationState> emit) {
    final updatedIngredients = state.ingredientItems.map((ingredientItem) {
      return ingredientItem == event.ingredientItem
          ? ingredientItem.copyWith(type: event.newType)
          : ingredientItem;
    }).toList();
    emit(state.copyWith(ingredientItems: updatedIngredients));
  }

  void _loadTools(
      LoadToolsEvent event, Emitter<CocktailCreationState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      print('Loading tools...');
      final tools = await repository.fetchTools();
      print('Loaded tools: $tools');
      emit(state.copyWith(tools: tools, isLoading: false));
    } catch (e) {
      print('Error loading tools: $e');
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  // Добавляем инструмент
  void _addTool(AddToolEvent event, Emitter<CocktailCreationState> emit) {
    print('Adding tool: ${event.tool.name}');
    final updatedTools = List<Tool>.from(state.selectedTools)..add(event.tool);
    emit(state.copyWith(selectedTools: updatedTools));
  }

  // Удаляем инструмент
  void _removeTool(RemoveToolEvent event, Emitter<CocktailCreationState> emit) {
    print('Removing tool: ${event.tool.name}');
    final updatedTools = List<Tool>.from(state.selectedTools)
      ..remove(event.tool);
    emit(state.copyWith(selectedTools: updatedTools));
  }

  void _onAddStep(AddStepEvent event, Emitter<CocktailCreationState> emit) {
    final updatedSteps = List<RecipeStep>.from(state.steps)..add(event.step);
    emit(state.copyWith(steps: updatedSteps));
  }

  void _onUpdateStep(
      UpdateStepEvent event, Emitter<CocktailCreationState> emit) {
    final updatedSteps = state.steps.map((step) {
      return step.number == event.step.number ? event.step : step;
    }).toList();
    emit(state.copyWith(steps: updatedSteps));
  }

  void _onRemoveStep(
      RemoveStepEvent event, Emitter<CocktailCreationState> emit) {
    // Удаляем шаг
    final updatedSteps =
        state.steps.where((step) => step.number != event.stepNumber).toList();

    // Обновляем номера шагов
    for (int i = 0; i < updatedSteps.length; i++) {
      updatedSteps[i] =
          RecipeStep(number: i + 1, description: updatedSteps[i].description);
    }

    emit(state.copyWith(steps: updatedSteps));
  }

  Future<void> _onUpdatePhoto(
      UpdatePhotoEvent event, Emitter<CocktailCreationState> emit) async {
    emit(state.copyWith(photo: event.photo));
  }

  void _onUpdateRecipeTitle(
      UpdateRecipeTitleEvent event, Emitter<CocktailCreationState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onUpdateRecipeDescription(
      UpdateRecipeDescriptionEvent event, Emitter<CocktailCreationState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onUpdateRecipeVideoUrl(
      UpdateRecipeVideoUrlEvent event, Emitter<CocktailCreationState> emit) {
    emit(state.copyWith(videoUrl: event.videoUrl));
  }

  void _onUpdateVideoFile(
      UpdateRecipeVideoFileEvent e, Emitter<CocktailCreationState> emit) {
    emit(state.copyWith(videoFile: e.file));
  }

  void _onUpdateVideoAwsKey(
      UpdateRecipeVideoAwsKeyEvent e, Emitter<CocktailCreationState> emit) {
    print('+++ Получен AWS ключ: ${e.awsKey}');
    emit(state.copyWith(videoAwsKey: e.awsKey));
  }

  Future<void> _onUploadVideoToS3(
    UploadVideoToS3Event e,
    Emitter<CocktailCreationState> emit,
  ) async {
    try {
      // 1) Генерим ключ
      final s3Key = const Uuid().v4().substring(0, 12);

      // 2) Получаем presigned URL
      final uploadUrl = await repository.getVideoUploadUrl(s3Key);

      // 3) Читаем байты
      final bytes = await e.videoFile.readAsBytes();

      // 4) Заливаем в S3
      await repository.uploadVideoToS3(uploadUrl, bytes);

      // 5) Сохраняем ключ в state
      emit(state.copyWith(videoAwsKey: s3Key));
    } catch (err) {
      emit(state.copyWith(submissionError: err.toString()));
    }
  }

  Future<void> _onSubmitRecipe(
    SubmitRecipeEvent event,
    Emitter<CocktailCreationState> emit,
  ) async {
    emit(state.copyWith(
        isSubmitting: true, submissionSuccess: false, submissionError: null));

    try {
      // ВАЛИДАЦИЯ: Проверка пустых шагов
      if (state.steps.isEmpty) {
        emit(state.copyWith(
          isSubmitting: false,
          submissionSuccess: false, // Явно сбрасываем success
          submissionError: 'Пожалуйста, добавьте шаги приготовления коктейля',
        ));
        return;
      }
      String? awsKey;
      // 1) Если видео выбрано — заливаем его в S3
      if (state.videoFile != null) {
        const accessKey = String.fromEnvironment('AWS_ACCESS_KEY_ID');
        const secretKey = String.fromEnvironment('AWS_SECRET_ACCESS_KEY');
        const region =
            String.fromEnvironment('AWS_REGION', defaultValue: 'us-east-2');
        const bucket = String.fromEnvironment('AWS_S3_BUCKET',
            defaultValue: 'cocktails-video-bucket');
        if (accessKey.isEmpty || secretKey.isEmpty) {
          emit(state.copyWith(
            isSubmitting: false,
            submissionSuccess: false,
            submissionError:
                'Для загрузки видео задайте AWS_ACCESS_KEY_ID и AWS_SECRET_ACCESS_KEY '
                '(например: flutter run --dart-define=AWS_ACCESS_KEY_ID=... --dart-define=AWS_SECRET_ACCESS_KEY=...).',
          ));
          return;
        }
        final String key = const Uuid().v4().substring(0, 12);
        print('Uploading video to S3 with key $key...');
        final String uploadedUrl = await AwsS3.uploadFile(
          accessKey: accessKey,
          secretKey: secretKey,
          region: region,
          bucket: bucket,
          destDir: '',
          filename: key,
          file: state.videoFile!,
          contentType: 'video/mp4',
        );
        if (uploadedUrl.isNotEmpty) {
          awsKey = key;
          print('Video uploaded: $uploadedUrl');
        } else {
          throw Exception('Video upload failed');
        }
      }

      // 2) Собираем данные для запроса
      // Удаляем дубли по ingredient.id, чтобы на бэке не было конфликтов
      final Map<int, IngredientItem> uniqueIngredients = {};
      for (final ing in state.ingredientItems) {
        uniqueIngredients.putIfAbsent(ing.ingredient.id, () => ing);
      }

      final ingredients = uniqueIngredients.values
          .map((ing) =>
              '{"ingredient":${ing.ingredient.id},"quantity":"${ing.quantity}","type":"${ing.type}"}')
          .join(',');
      final tools = state.selectedTools.map((t) => t.id).join(',');
      final instructions = <String, String>{};
      for (var step in state.steps) {
        instructions[step.number.toString()] = step.description;
      }
      final profileData = await ProfileRepository().getProfileFromCache();
      final userId = profileData?['id'] ?? (throw Exception('No user'));

      final data = <String, dynamic>{
        'title': state.title,
        'description': state.description,
        'ingredients': ingredients,
        'tools': tools,
        'instruction': jsonEncode(instructions),
        'user': userId,
      };
      // 3) Добавляем только видео-ключ, а не сам файл
      if (awsKey != null) {
        data['video_aws_key'] = awsKey;
      } else if (state.videoUrl.isNotEmpty) {
        data['video_url'] = state.videoUrl;
      }
      if (state.photo != null) {
        data['photo'] = await MultipartFile.fromFile(state.photo!.path);
      }

      // 4) Отправляем рецепт
      await repository.createRecipe(data);
      emit(state.copyWith(
        isSubmitting: false,
        submissionSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        submissionSuccess: false, // Явно сбрасываем success
        submissionError: e.toString(),
      ));
    }
  }
}
