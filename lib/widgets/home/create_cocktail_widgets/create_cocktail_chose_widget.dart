import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import '../../../models/create_cocktail_model.dart';
import '../../../models/ingredient_category_model.dart';
import '../../custom_checkbox.dart';

class NewCocktailView extends StatefulWidget {
  final int step;

  const NewCocktailView({super.key, required this.step});

  @override
  NewCocktailViewState createState() => NewCocktailViewState();
}

class NewCocktailViewState extends State<NewCocktailView> {
  @override
  void initState() {
    super.initState();
    context.read<CocktailCreationBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = BlocProvider.of<CocktailCreationBloc>(context);

    return BlocBuilder<CocktailCreationBloc, CocktailCreationState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(
            child: Text(
              tr("errors.server_error"),
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // 0 - alcoholic
        // 1 - non-alcoholic

        List<Section> sections = state.sections.toList();

        // В создании коктейля шаги должны соответствовать фильтрам каталога:
        // step == 1: алкогольные напитки     → НЕ продукты + category.isAlcoholic == true
        // step == 2: б/а напитки             → НЕ продукты + category.isAlcoholic == false
        // step == 3: продукты                → section.isProduct == true (любой category.isAlcoholic)
        final categories = sections.expand((section) {
          if (widget.step == 1) {
            return !section.isProduct
                ? section.categories.where((c) => c.isAlcoholic == true)
                : <Category>[];
          } else if (widget.step == 3) {
            return section.isProduct ? section.categories : <Category>[];
          } else {
            return !section.isProduct
                ? section.categories.where((c) => c.isAlcoholic == false)
                : <Category>[];
          }
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSelectedIngredientsTable(
                context, cocktailBloc, state, widget.step),
            const SizedBox(height: 24),
            Text(
              widget.step == 1
                  ? tr('cocktail_selection.step_base')
                  : tr('cocktail_selection.additional_ingredients'),
              style: context.text.bodyText16White,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final filteredItems = widget.step == 1
                      ? category.ingredients
                          .where((ing) => ing.isAlcoholic == true)
                          .toList()
                      : widget.step == 2
                          ? category.ingredients
                              .where((ing) => ing.isAlcoholic == false)
                              .toList()
                          : category.ingredients;
                  return buildExpansionTile(
                    context,
                    cocktailBloc,
                    state,
                    widget.step,
                    category.name,
                    filteredItems,
                    isFirst: index == 0,
                    isLast: index == categories.length - 1,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Таблица для отображения выбранных ингредиентов
  Widget buildSelectedIngredientsTable(
    BuildContext context,
    CocktailCreationBloc cocktailBloc,
    CocktailCreationState state,
    int sectionId,
  ) {
    final selectedItems = state.ingredientItems
        .where((item) => item.sectionId == sectionId)
        .toList();

    if (selectedItems.isEmpty) {
      return Container();
    }
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF343434), width: 1),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(0.02),
          ),
          child: Column(
            children: selectedItems.map((ingredientItem) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF343434), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          border: Border(
                            right:
                                BorderSide(color: Color(0xFF343434), width: 1),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        child: Text(
                          ingredientItem.ingredient.name,
                          style: context.text.bodyText14White
                              .copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          border: Border(
                            right:
                                BorderSide(color: Color(0xFF343434), width: 1),
                          ),
                        ),
                        child: Center(
                          child: TextFormField(
                            initialValue: ingredientItem.quantity,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              cocktailBloc.add(UpdateIngredientQuantityEvent(
                                ingredientItem,
                                value,
                              ));
                            },
                            style: context.text.bodyText14White,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: ingredientItem.type,
                              items: ['ml', 'g', 'oz', 'tbsp', 'tsp']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: context.text.bodyText14White),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  cocktailBloc.add(UpdateIngredientTypeEvent(
                                    ingredientItem,
                                    newValue,
                                  ));
                                }
                              },
                              dropdownColor: Colors.black,
                              style: context.text.bodyText14White,
                              icon: const SizedBox
                                  .shrink(), // Убираем треугольник (иконку)
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: selectedItems.map((ingredientItem) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  // Удаляем ингредиент
                  cocktailBloc.add(RemoveIngredientEvent(ingredientItem));
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Отображение категорий ингредиентов
  Widget buildExpansionTile(
      BuildContext context,
      CocktailCreationBloc cocktailBloc,
      CocktailCreationState state,
      int step,
      String category,
      List<Ingredients> items, // Список ингредиентов для данной категории
      {bool isFirst = false,
      bool isLast = false}) {
    final ScrollController scrollController = ScrollController();

    // Получаем выбранные ингредиенты для данной категории и секции
    final selectedIngredients = state.ingredientItems
        .where((item) => item.sectionId == step && item.category == category)
        .toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff343434)),
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(10.0) : Radius.zero,
          bottom: isLast ? const Radius.circular(10.0) : Radius.zero,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Убираем разделитель
        ),
        child: ExpansionTile(
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$category  ',
                  style: context.text.bodyText16White, // Стиль текста
                ),
                TextSpan(
                  text:
                      '(${selectedIngredients.length} ${tr('cocktail_selection.selected')})',
                  style: context.text.bodyText12Grey.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 14.0),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  bottom: isLast ? const Radius.circular(10.0) : Radius.zero,
                ),
              ),
              child: SizedBox(
                height: 150, // Ограничиваем высоту виджета
                child: Scrollbar(
                  radius: const Radius.circular(30),
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 4,
                  child: ListView(
                    controller: scrollController,
                    children: items.map((item) {
                      // Проверяем, выбран ли ингредиент
                      final isSelected = selectedIngredients.any(
                          (selectedItem) =>
                              selectedItem.ingredient.id == item.id);

                      return CustomCheckboxListTile(
                        title: item.name,
                        value: isSelected,
                        onChanged: (bool? selected) {
                          if (selected == true) {
                            cocktailBloc.add(AddIngredientEvent(
                              IngredientItem(
                                ingredient: item,
                                quantity: '100',
                                // Стартовое количество
                                type: 'ml',
                                // Стартовый тип
                                sectionId: step,
                                category: category,
                              ),
                            ));
                          } else {
                            final selectedItem = selectedIngredients.firstWhere(
                              (selectedItem) =>
                                  selectedItem.ingredient.id == item.id,
                            );
                            cocktailBloc
                                .add(RemoveIngredientEvent(selectedItem));
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
