import 'package:cocktails/pages/catalog/filter_pages/products_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import '../../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/catalog_widgets/catalog_selected_wrap.dart';
import '../../../widgets/catalog_widgets/sort_expansion_tile.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/home/create_cocktail_widgets/change_cocktail_tile.dart';
import 'alcoholic_page.dart';
import 'non_alcoholic_page.dart';

class FilterMainPage extends StatefulWidget {
  final bool catalogPage;

  const FilterMainPage({super.key, required this.catalogPage});

  @override
  State<FilterMainPage> createState() => _FilterMainPageState();
}

class _FilterMainPageState extends State<FilterMainPage> {
  late String _selectedSortOption;

  @override
  void initState() {
    super.initState();
    // Читаем текущую сортировку из правильного блока
    if (widget.catalogPage) {
      final alcState = context.read<AlcoholicCocktailBloc>().state;
      _selectedSortOption = alcState is CocktailSearchLoaded
          ? alcState.currentSortOption
          : 'title';
    } else {
      final listState = context.read<CocktailListBloc>().state;
      _selectedSortOption = listState is CocktailSearchLoaded
          ? listState.currentSortOption
          : 'title';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("catalog_page.filter"),
      onPressed: null,
      arrow: false,
      child: BlocBuilder<IngredientSelectionBloc, IngredientSelectionState>(
        builder: (context, state) {
          final alcoholicCount = _getSelectedCount(state, 1);
          final nonAlcoholicCount = _getSelectedCount(state, 2);
          final productsCount = _getSelectedCount(state, 3);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SortExpansionTile(
                currentSortOption: _selectedSortOption,
                onSortChanged: (newSort) {
                  setState(() => _selectedSortOption = newSort);
                },
              ),
              const SizedBox(height: 16),
              const CatalogSelectedItemsWrap(),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFF343434), width: 1.0),
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChangeCocktailTile(
                      name: tr('new_recipe.alcoholic_drinks'),
                      selectedCount: alcoholicCount,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AlcoholicPage(),
                          ),
                        );
                      },
                    ),
                    ChangeCocktailTile(
                      name: tr('new_recipe.non_alcoholic_drinks'),
                      selectedCount: nonAlcoholicCount,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const NonAlcoholicPage(),
                          ),
                        );
                      },
                    ),
                    ChangeCocktailTile(
                      name: tr('new_recipe.ingredients'),
                      selectedCount: productsCount,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProductsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: CustomButton(
                        text: tr("buttons.cancel"),
                        grey: true,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        single: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: CustomButton(
                        text: tr("buttons.confirm"),
                        onPressed: () {
                          final ingredients = _getSelectedIngredients(
                            context.read<IngredientSelectionBloc>().state,
                          );
                          if (widget.catalogPage) {
                            context.read<AlcoholicCocktailBloc>().add(
                                  SearchCocktails(
                                    ordering: _selectedSortOption,
                                    ingredients: ingredients,
                                    alc: true,
                                  ),
                                );
                            context.read<NonAlcoholicCocktailBloc>().add(
                                  SearchCocktails(
                                    ordering: _selectedSortOption,
                                    ingredients: ingredients,
                                    alc: false,
                                  ),
                                );
                          } else {
                            context.read<CocktailListBloc>().add(
                                  SearchCocktails(
                                    ordering: _selectedSortOption,
                                    ingredients: ingredients,
                                  ),
                                );
                          }
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        single: false,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
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
    return selectedIngredientsIds.join(',');
  }

  // Функция для получения количества выбранных ингредиентов в категории по id
  int _getSelectedCount(IngredientSelectionState state, int sectionId) {
    // Проверяем, есть ли в состоянии секция с указанным ID
    final section = state.selectedItems[sectionId];

    if (section == null) {
      // Если секция отсутствует, возвращаем 0
      return 0;
    }

    // Подсчитываем все выбранные ингредиенты в каждой категории секции
    return section.entries.fold<int>(0, (total, categoryEntry) {
      return total + categoryEntry.value.length;
    });
  }
}
