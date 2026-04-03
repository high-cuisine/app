import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/cocktail_list_model.dart';
import '../../provider/cocktail_list_get.dart';
import '../../utilities/language_swich.dart';

part 'cocktail_list_event.dart';
part 'cocktail_list_state.dart';

class CocktailListBloc extends Bloc<CocktailListEvent, CocktailListState> {
  final CocktailRepository repository;

  CocktailListBloc(this.repository) : super(CocktailInitial()) {
    on<FetchCocktailById>(_onFetchCocktailById);
    on<FetchCocktails>(_onFetchCocktails);
    on<FetchUserCocktails>(_onFetchUserCocktails); // Обрабатываем новый ивент
    on<SearchCocktails>(_onSearchCocktails);
    on<SearchCocktailsLoadMore>(_onSearchCocktailsLoadMore);
    on<FetchFavoriteCocktails>(_onFetchFavoriteCocktails);
    on<SearchFavoriteCocktails>(_onSearchFavoriteCocktails);
    on<ToggleFavoriteCocktail>(_onToggleFavoriteCocktail);
    on<ClaimCocktail>(_onClaimCocktail);
    on<PublishCocktail>(_onPublishCocktail);
  }

  void _onFetchCocktailById(
      FetchCocktailById event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading()); // Показать состояние загрузки

    try {
      final cocktail = await repository.fetchCocktailById(event.cocktailId);
      print(cocktail.photo);
      emit(CocktailByIdLoaded(cocktail)); // Эмитим состояние с коктейлем по ID
    } catch (e, stacktrace) {
      log('Error fetching cocktail by ID', error: e, stackTrace: stacktrace);
      emit(CocktailError('Failed to fetch cocktail: ${e.toString()}'));
    }
  }

  void _onFetchCocktails(
      FetchCocktails event, Emitter<CocktailListState> emit) async {
    final currentState = state;

    // page == 1 → полная перезагрузка (смена языка, открытие каталога и т.д.)
    // page > 1 и уже есть данные → подгрузка следующей страницы (infinite scroll)
    if (currentState is CocktailLoaded && event.page > 1) {
      try {
        final newCocktails = await repository.fetchCocktails(
          page: event.page,
          pageSize: event.pageSize,
          alc: event.alc,
        );

        if (newCocktails.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else if (newCocktails.length < event.pageSize) {
          emit(currentState.copyWith(
            cocktails: currentState.cocktails + newCocktails,
            hasReachedMax: true,
          ));
        } else {
          emit(currentState.copyWith(
            cocktails: currentState.cocktails + newCocktails,
            hasReachedMax: false,
          ));
        }
      } catch (e, stacktrace) {
        log('Error fetching more cocktails', error: e, stackTrace: stacktrace);
        emit(CocktailError('Failed to load more cocktails: ${e.toString()}'));
      }
    } else {
      emit(CocktailLoading());
      try {
        final raw = await repository.fetchCocktails(
          page: event.page,
          pageSize: event.pageSize,
          alc: event.alc,
        );
        final cocktails = sortByLocale(raw, 'title');

        if (cocktails.length < event.pageSize) {
          emit(CocktailLoaded(cocktails, 'title', hasReachedMax: true));
        } else {
          emit(CocktailLoaded(cocktails, 'title', hasReachedMax: false));
        }
      } catch (e, stacktrace) {
        log('Error fetching cocktails', error: e, stackTrace: stacktrace);
        emit(CocktailError('Failed to fetch cocktails: ${e.toString()}'));
      }
    }
  }

  // Получение коктейлей пользователя (с аутентификацией)
  void _onFetchUserCocktails(
      FetchUserCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final userCocktails = await repository.fetchUserCocktails(
        query: event.query,
        page: event.page,
        pageSize: event.pageSize,
      );
      emit(UserCocktailLoaded(userCocktails));
    } catch (e, stacktrace) {
      log('Error fetching user cocktails', error: e, stackTrace: stacktrace);
      emit(CocktailError('Failed to fetch user cocktails: ${e.toString()}'));
    }
  }

  void _onSearchCocktails(
      SearchCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      print(event.ingredients);
      final cocktailsResponse = await repository.searchCocktails(
        query: event.query,
        ingredients: event.ingredients,
        tools: event.tools,
        ordering: event.ordering,
        page: event.page,
        pageSize: event.pageSize,
        alc: event.alc,
      );

      final ordering = event.ordering ?? 'title';
      final sorted = sortByLocale(cocktailsResponse.cocktails, ordering);

      emit(CocktailSearchLoaded(
        sorted,
        ordering,
        hasReachedMax: cocktailsResponse.cocktails.length < event.pageSize,
        count: cocktailsResponse.count,
      ));
    } catch (e, stacktrace) {
      log('Error searching cocktails: $e', error: e, stackTrace: stacktrace);
      emit(CocktailError('Failed to search cocktails: $e'));
    }
  }

  void _onSearchCocktailsLoadMore(
      SearchCocktailsLoadMore event, Emitter<CocktailListState> emit) async {
    final currentState = state;
    if (currentState is CocktailSearchLoaded) {
      try {
        print(event.query);
        print(event.page);
        print(event.ingredients);
        print(event.pageSize);
        // Загружаем следующую страницу
        final newCocktails = await repository.searchCocktails(
          query: event.query,
          ingredients: event.ingredients,
          tools: event.tools,
          ordering: event.ordering,
          page: event.page,
          pageSize: event.pageSize,
          alc: event.alc,
        );

        if (newCocktails.cocktails.isEmpty) {
          // Если новых данных нет, не обновляем состояние
          emit(currentState.copyWith(hasReachedMax: true));
        } else if (newCocktails.cocktails.length < event.pageSize) {
          // Если количество полученных коктейлей меньше, чем запрашивалось
          emit(currentState.copyWith(
            cocktails: currentState.cocktails + newCocktails.cocktails,
            hasReachedMax: true, // Устанавливаем, что больше нет данных
          ));
        } else {
          // Обновляем список коктейлей, добавляя новые элементы
          emit(currentState.copyWith(
            cocktails: currentState.cocktails + newCocktails.cocktails,
            hasReachedMax: false,
          ));
        }
      } catch (e, stacktrace) {
        log('Error fetching more cocktails', error: e, stackTrace: stacktrace);
        emit(CocktailError('Failed to load more cocktails: ${e.toString()}'));
      }
    }
  }

  void _onFetchFavoriteCocktails(
      FetchFavoriteCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final favoriteCocktails = await repository.fetchFavoriteCocktails();
      emit(CocktailLoaded(favoriteCocktails, 'title'));
    } catch (e) {
      emit(CocktailError(
          'Не удалось загрузить избранные рецепты: ${e.toString()}'));
    }
  }

  void _onSearchFavoriteCocktails(
      SearchFavoriteCocktails event, Emitter<CocktailListState> emit) async {
    emit(CocktailLoading());
    try {
      final cocktails = await repository.searchFavoriteCocktails(
        query: event.query,
        ingredients: event.ingredients,
        tools: event.tools,
        ordering: event.ordering,
        page: event.page,
        pageSize: event.pageSize,
      );

      emit(CocktailLoaded(cocktails, 'title',
          hasReachedMax: cocktails.length <
              event.pageSize)); // Устанавливаем состояние hasReachedMax
    } catch (e) {
      emit(CocktailError(e.toString()));
    }
  }

  void _onToggleFavoriteCocktail(
      ToggleFavoriteCocktail event, Emitter<CocktailListState> emit) async {
    final currentState = state;

    if (currentState is CocktailLoaded) {
      final updatedLoadingStates =
          Map<int, bool>.from(currentState.loadingStates);
      updatedLoadingStates[event.cocktailId] =
          true; // Устанавливаем состояние загрузки для конкретного коктейля

      emit(CocktailLoaded(
          currentState.cocktails, currentState.currentSortOption,
          loadingStates: updatedLoadingStates));

      try {
        await repository.toggleFavorite(event.cocktailId, event.isFavorite);

        updatedLoadingStates[event.cocktailId] =
            false; // Сбрасываем состояние загрузки

        // После изменения избранного обновляем список избранных коктейлей
        if (event.favoritePage) {
          add(const FetchFavoriteCocktails()); // Повторный запрос избранных коктейлей
        } else {
          final cocktails = await repository.fetchCocktails();
          emit(CocktailLoaded(cocktails, currentState.currentSortOption,
              loadingStates: updatedLoadingStates));
        }
      } catch (e) {
        emit(CocktailError(
            'Не удалось изменить статус избранного: ${e.toString()}'));
      }
    }
    if (currentState is CocktailSearchLoaded) {
      final updatedLoadingStates =
          Map<int, bool>.from(currentState.loadingStates);
      updatedLoadingStates[event.cocktailId] = true;

      // Сначала эмитим состояние с флагом загрузки
      emit(currentState.copyWith(loadingStates: updatedLoadingStates));

      try {
        await repository.toggleFavorite(event.cocktailId, event.isFavorite);

        updatedLoadingStates[event.cocktailId] = false;

        // Обновляем данные коктейлей в избранном
        if (event.favoritePage) {
          add(const FetchFavoriteCocktails());
        } else {
          // Обновляем локально коктейли, изменяя только `isFavorite`
          final updatedCocktails = currentState.cocktails.map((cocktail) {
            if (cocktail.id == event.cocktailId) {
              return cocktail.copyWith(
                  isFavorite: !cocktail.isFavorite); // Инверсия значения
            }
            return cocktail;
          }).toList();

          emit(currentState.copyWith(
            cocktails: updatedCocktails,
            loadingStates: updatedLoadingStates,
          ));
        }
      } catch (e) {
        emit(CocktailError(
            'Не удалось изменить статус избранного: ${e.toString()}'));
      }
    }
  }

  void _onClaimCocktail(
      ClaimCocktail event, Emitter<CocktailListState> emit) async {
    final currentState = state;

    if (currentState is CocktailLoaded) {
      // Если мы в состоянии обычного списка
      try {
        await repository.claimRecipe(event.cocktailId);

        final updatedCocktails = currentState.cocktails.map((cocktail) {
          return cocktail.id == event.cocktailId
              ? cocktail.copyWith(claimed: true)
              : cocktail;
        }).toList();

        emit(CocktailLoaded(updatedCocktails, currentState.currentSortOption));
      } catch (e) {
        emit(
            CocktailError('Не удалось отметить рецепт как приготовленный: $e'));
      }
    } else if (currentState is CocktailSearchLoaded) {
      // Если мы в состоянии поиска
      try {
        await repository.claimRecipe(event.cocktailId);

        final updatedCocktails = currentState.cocktails.map((cocktail) {
          return cocktail.id == event.cocktailId
              ? cocktail.copyWith(claimed: true)
              : cocktail;
        }).toList();

        emit(currentState.copyWith(cocktails: updatedCocktails));
      } catch (e) {
        emit(
            CocktailError('Не удалось отметить рецепт как приготовленный: $e'));
      }
    }
  }

  void _onPublishCocktail(
      PublishCocktail event, Emitter<CocktailListState> emit) async {
    final currentState = state;
    print("PublishCocktail event received: ${event.cocktailId}");
    print(currentState.toString());
    if (currentState is UserCocktailLoaded) {
      emit(CocktailLoading()); // Показать состояние загрузки
      print(currentState.toString());
      try {
        await repository.publishCocktail(event.cocktailId);
        final updatedCocktails = currentState.userCocktails.map((cocktail) {
          return cocktail.id == event.cocktailId
              ? cocktail.copyWith(
                  moderationStatus: 'Pending') // Обновляем статус
              : cocktail;
        }).toList();

        emit(UserCocktailLoaded(updatedCocktails));
      } catch (e) {
        emit(CocktailError('Не удалось опубликовать коктейль: $e'));
      }
    }
  }

  /// Сортировка с учётом локали: слова на языке пользователя идут первыми,
  /// а внутри каждой группы используется стандартное лексикографическое
  /// сравнение (кириллица и латиница оба отсортированы верно в Unicode).
  static List<Cocktail> sortByLocale(
      List<Cocktail> cocktails, String ordering) {
    if (ordering != 'title' && ordering != '-title') return cocktails;

    final lang = LanguageService.currentLanguage;
    final ascending = ordering == 'title';

    final sorted = List<Cocktail>.from(cocktails)
      ..sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();
        final aIsCyrillic = _startsCyrillic(aName);
        final bIsCyrillic = _startsCyrillic(bName);

        // Ставим слова на языке пользователя перед словами на другом языке
        if (lang == 'rus') {
          if (aIsCyrillic && !bIsCyrillic) return ascending ? -1 : 1;
          if (!aIsCyrillic && bIsCyrillic) return ascending ? 1 : -1;
        } else {
          if (!aIsCyrillic && bIsCyrillic) return ascending ? -1 : 1;
          if (aIsCyrillic && !bIsCyrillic) return ascending ? 1 : -1;
        }

        final cmp = aName.compareTo(bName);
        return ascending ? cmp : -cmp;
      });
    return sorted;
  }

  static bool _startsCyrillic(String s) {
    if (s.isEmpty) return false;
    final code = s.codeUnitAt(0);
    // Кириллица в Unicode: U+0410–U+044F (заглавные и строчные)
    return code >= 0x0410 && code <= 0x044F;
  }
}

class AlcoholicCocktailBloc extends CocktailListBloc {
  AlcoholicCocktailBloc(super.repository);

  @override
  void _onToggleFavoriteCocktail(
      ToggleFavoriteCocktail event, Emitter<CocktailListState> emit) async {
    final currentState = state;
    if (currentState is CocktailLoaded) {
      final updatedLoadingStates =
          Map<int, bool>.from(currentState.loadingStates);
      updatedLoadingStates[event.cocktailId] = true;
      emit(CocktailLoaded(
          currentState.cocktails, currentState.currentSortOption,
          loadingStates: updatedLoadingStates));
      try {
        await repository.toggleFavorite(event.cocktailId, event.isFavorite);
        updatedLoadingStates[event.cocktailId] = false;
        if (event.favoritePage) {
          add(const FetchFavoriteCocktails());
        } else {
          // Вызов с передачей alc: true для алкогольного блока
          final updatedCocktails = currentState.cocktails.map((cocktail) {
            if (cocktail.id == event.cocktailId) {
              return cocktail.copyWith(
                  isFavorite: !cocktail.isFavorite); // Инверсия значения
            }
            return cocktail;
          }).toList();

          emit(currentState.copyWith(
            cocktails: updatedCocktails,
            loadingStates: updatedLoadingStates,
          ));
        }
      } catch (e) {
        emit(CocktailError(
            'Не удалось изменить статус избранного: ${e.toString()}'));
      }
    }
    if (currentState is CocktailSearchLoaded) {
      final updatedLoadingStates =
          Map<int, bool>.from(currentState.loadingStates);
      updatedLoadingStates[event.cocktailId] = true;

      // Сначала эмитим состояние с флагом загрузки
      emit(currentState.copyWith(loadingStates: updatedLoadingStates));

      try {
        await repository.toggleFavorite(event.cocktailId, event.isFavorite);

        updatedLoadingStates[event.cocktailId] = false;

        // Обновляем данные коктейлей в избранном
        if (event.favoritePage) {
          add(const FetchFavoriteCocktails());
        } else {
          // Обновляем локально коктейли, изменяя только `isFavorite`
          final updatedCocktails = currentState.cocktails.map((cocktail) {
            if (cocktail.id == event.cocktailId) {
              return cocktail.copyWith(
                  isFavorite: !cocktail.isFavorite); // Инверсия значения
            }
            return cocktail;
          }).toList();

          emit(currentState.copyWith(
            cocktails: updatedCocktails,
            loadingStates: updatedLoadingStates,
          ));
        }
      } catch (e) {
        emit(CocktailError(
            'Не удалось изменить статус избранного: ${e.toString()}'));
      }
    }
    // Аналогично обработать случай, если состояние — CocktailSearchLoaded
  }
}

class NonAlcoholicCocktailBloc extends CocktailListBloc {
  NonAlcoholicCocktailBloc(super.repository);

  @override
  void _onToggleFavoriteCocktail(
      ToggleFavoriteCocktail event, Emitter<CocktailListState> emit) async {
    final currentState = state;
    if (currentState is CocktailLoaded) {
      final updatedLoadingStates =
          Map<int, bool>.from(currentState.loadingStates);
      updatedLoadingStates[event.cocktailId] = true;
      emit(CocktailLoaded(
          currentState.cocktails, currentState.currentSortOption,
          loadingStates: updatedLoadingStates));
      try {
        await repository.toggleFavorite(event.cocktailId, event.isFavorite);
        updatedLoadingStates[event.cocktailId] = false;
        if (event.favoritePage) {
          add(const FetchFavoriteCocktails());
        } else {
          final updatedCocktails = currentState.cocktails.map((cocktail) {
            if (cocktail.id == event.cocktailId) {
              return cocktail.copyWith(
                  isFavorite: !cocktail.isFavorite); // Инверсия значения
            }
            return cocktail;
          }).toList();

          emit(currentState.copyWith(
            cocktails: updatedCocktails,
            loadingStates: updatedLoadingStates,
          ));
        }
      } catch (e) {
        emit(CocktailError(
            'Не удалось изменить статус избранного: ${e.toString()}'));
      }
    }
    if (currentState is CocktailSearchLoaded) {
      final updatedLoadingStates =
          Map<int, bool>.from(currentState.loadingStates);
      updatedLoadingStates[event.cocktailId] = true;

      // Сначала эмитим состояние с флагом загрузки
      emit(currentState.copyWith(loadingStates: updatedLoadingStates));

      try {
        await repository.toggleFavorite(event.cocktailId, event.isFavorite);

        updatedLoadingStates[event.cocktailId] = false;

        // Обновляем данные коктейлей в избранном
        if (event.favoritePage) {
          add(const FetchFavoriteCocktails());
        } else {
          // Обновляем локально коктейли, изменяя только `isFavorite`
          final updatedCocktails = currentState.cocktails.map((cocktail) {
            if (cocktail.id == event.cocktailId) {
              return cocktail.copyWith(
                  isFavorite: !cocktail.isFavorite); // Инверсия значения
            }
            return cocktail;
          }).toList();

          emit(currentState.copyWith(
            cocktails: updatedCocktails,
            loadingStates: updatedLoadingStates,
          ));
        }
      } catch (e) {
        emit(CocktailError(
            'Не удалось изменить статус избранного: ${e.toString()}'));
      }
    }
    // Аналогично обработать случай, если состояние — CocktailSearchLoaded
  }
}
