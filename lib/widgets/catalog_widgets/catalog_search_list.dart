import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import '../../models/cocktail_list_model.dart';
import '../cocktail_list/cocktail_card.dart';

class CatalogSearchList extends StatefulWidget {
  const CatalogSearchList({
    super.key,
    required this.searchList,
    required this.hasReachedMax,
    required this.query,
    this.catalogPage = false,
    this.alcoholPage = false,
    this.searchPage = false,
  });

  final List<Cocktail> searchList;
  final bool hasReachedMax;
  final String query;
  final bool catalogPage;
  final bool alcoholPage;
  final bool searchPage;

  @override
  State<CatalogSearchList> createState() => _CatalogSearchListState();
}

class _CatalogSearchListState extends State<CatalogSearchList> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Добавляем обработчик скролла для подгрузки новых страниц
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _currentPage++;
        if (widget.catalogPage) {
          final CocktailListBloc bloc = widget.alcoholPage
              ? context.read<AlcoholicCocktailBloc>()
              : context.read<NonAlcoholicCocktailBloc>();

          final state = bloc.state;
          if (state is! CocktailSearchLoaded) return;
          if (!state.hasReachedMax) {
            print("$_currentPage в серч листе");
            bloc.add(
              SearchCocktailsLoadMore(
                page: _currentPage,
                query: widget.query,
                ordering: state.currentSortOption,
                alc: widget.alcoholPage,
                ingredients: widget.searchPage != true
                    ? _getSearchSelectedIngredients(
                        context.read<CocktailSelectionBloc>(),
                      )
                    : _getSelectedIngredients(
                        context.read<IngredientSelectionBloc>().state,
                      ),
              ),
            );
          }
        } else {
          if (!(context.read<CocktailListBloc>().state as CocktailSearchLoaded)
              .hasReachedMax) {
            print("$_currentPage в серч листе");
            final bloc = context.read<CocktailListBloc>();
            final state = bloc.state;
            if (state is! CocktailSearchLoaded) return;
            bloc.add(
              SearchCocktailsLoadMore(
                page: _currentPage,
                query: widget.query,
                ordering: state.currentSortOption,
                ingredients: widget.searchPage != true
                    ? _getSearchSelectedIngredients(
                        context.read<CocktailSelectionBloc>(),
                      )
                    : _getSelectedIngredients(
                        context.read<IngredientSelectionBloc>().state,
                      ),
              ),
            );
          }
        }
        // Когда дошли до конца списка и если еще есть данные для загрузки
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.hasReachedMax
          ? widget.searchList.length
          : widget.searchList.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.searchList.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return CocktailCard(
            catalogPage: widget.catalogPage,
            alcoholPage: widget.alcoholPage,
            cocktail: widget.searchList[index],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getSelectedIngredients(IngredientSelectionState state) {
    final selectedItems = state.selectedItems;
    List<String> selectedIngredientsIds = [];

    // Проходим по всем секциям и категориям
    selectedItems.forEach((sectionId, categories) {
      categories.forEach((categoryId, ingredients) {
        // Собираем идентификаторы ингредиентов
        selectedIngredientsIds
            .addAll(ingredients.map((ingredient) => ingredient.id.toString()));
      });
    });
    // Возвращаем строку с идентификаторами ингредиентов через запятую
    print("${selectedIngredientsIds.join(',')} это в методе каталога");
    return selectedIngredientsIds.join(',');
  }

  String _getSearchSelectedIngredients(
      CocktailSelectionBloc cocktailSelectionBloc) {
    // Получаем идентификаторы выбранных ингредиентов
    final selectedIngredientIds =
        cocktailSelectionBloc.getSelectedIngredientIds();

    // Проверяем, что есть выбранные идентификаторы
    if (selectedIngredientIds.isNotEmpty) {
      print(
          "${selectedIngredientIds.join(',')} это в методе для CocktailSelectionState");
      return selectedIngredientIds.join(',');
    }

    // Возвращаем пустую строку, если нет выбранных ингредиентов
    return '';
  }
}
