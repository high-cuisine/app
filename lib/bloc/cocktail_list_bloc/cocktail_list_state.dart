part of 'cocktail_list_bloc.dart';

// States
abstract class CocktailListState extends Equatable {
  const CocktailListState();

  @override
  List<Object> get props => [];
}

class CocktailInitial extends CocktailListState {}

class CocktailByIdLoaded extends CocktailListState {
  final Cocktail cocktail;

  CocktailByIdLoaded(this.cocktail);
}

class CocktailLoading extends CocktailListState {}

class CocktailSearchLoaded extends CocktailListState {
  final List<Cocktail> cocktails;
  final String currentSortOption;
  final Map<int, bool> loadingStates;
  final bool hasReachedMax; // Добавляем флаг для пагинации
  final int count;

  const CocktailSearchLoaded(
    this.cocktails,
    this.currentSortOption, {
    required this.count,
    this.loadingStates = const {},
    this.hasReachedMax = false,
  });

  // Метод copyWith для обновления состояния
  CocktailSearchLoaded copyWith({
    List<Cocktail>? cocktails,
    String? currentSortOption,
    Map<int, bool>? loadingStates,
    bool? hasReachedMax,
    int? count,
  }) {
    return CocktailSearchLoaded(
      cocktails ?? this.cocktails,
      currentSortOption ?? this.currentSortOption,
      loadingStates: loadingStates ?? this.loadingStates,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      count: count ?? this.count,
    );
  }

  @override
  List<Object> get props =>
      [cocktails, currentSortOption, loadingStates, hasReachedMax, count];
}

class CocktailLoaded extends CocktailListState {
  final List<Cocktail> cocktails;
  final String currentSortOption;
  final Map<int, bool> loadingStates;
  final bool hasReachedMax; // Добавляем флаг для пагинации
  final int count;

  const CocktailLoaded(
    this.cocktails,
    this.currentSortOption, {
    this.count = 0,
    this.loadingStates = const {},
    this.hasReachedMax = false,
  });

  // Метод copyWith для обновления состояния
  CocktailLoaded copyWith({
    List<Cocktail>? cocktails,
    String? currentSortOption,
    Map<int, bool>? loadingStates,
    bool? hasReachedMax,
  }) {
    return CocktailLoaded(
      cocktails ?? this.cocktails,
      currentSortOption ?? this.currentSortOption,
      loadingStates: loadingStates ?? this.loadingStates,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props =>
      [cocktails, currentSortOption, loadingStates, hasReachedMax];
}

class UserCocktailLoaded extends CocktailListState {
  final List<Cocktail> userCocktails;
  final Map<int, bool> loadingStates;
  final bool hasReachedMax;
  final int count;

  const UserCocktailLoaded(
    this.userCocktails, {
    this.count = 0,
    this.loadingStates = const {},
    this.hasReachedMax = false,
  });

  UserCocktailLoaded copyWith({
    List<Cocktail>? userCocktails,
    Map<int, bool>? loadingStates,
    bool? hasReachedMax,
    int? count,
  }) {
    return UserCocktailLoaded(
      userCocktails ?? this.userCocktails,
      loadingStates: loadingStates ?? this.loadingStates,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      count: count ?? this.count,
    );
  }

  @override
  List<Object> get props =>
      [userCocktails, loadingStates, hasReachedMax, count];
}

class CocktailError extends CocktailListState {
  final String message;

  const CocktailError(this.message);

  @override
  List<Object> get props => [message];
}
