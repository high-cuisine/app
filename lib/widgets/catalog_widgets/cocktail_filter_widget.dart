import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/catalog_filter_bloc/catalog_filter_bloc.dart';
import '../../models/ingredient_category_model.dart';
import '../custom_checkbox.dart';

class CocktailFilterView extends StatefulWidget {
  final int step;

  const CocktailFilterView({super.key, required this.step});

  @override
  CocktailFilterViewState createState() => CocktailFilterViewState();
}

class CocktailFilterViewState extends State<CocktailFilterView> {
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    context.read<IngredientSelectionBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = BlocProvider.of<IngredientSelectionBloc>(context);

    return BlocBuilder<IngredientSelectionBloc, IngredientSelectionState>(
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

        // step == 1: алкогольные напитки   → категории с isAlcoholic == true
        // step == 2: б/а напитки           → секции с isProduct == false и категории с isAlcoholic == false
        // step == 3: продукты              → секции с isProduct == true
        final categories = sections.expand((section) {
          if (widget.step == 1) {
            return section.categories
                .where((category) => category.isAlcoholic == true);
          } else if (widget.step == 3) {
            return section.isProduct ? section.categories : <Category>[];
          } else {
            // step == 2: б/а напитки — неалкогольные секции, кроме "Продукты"
            return !section.isProduct
                ? section.categories
                    .where((category) => category.isAlcoholic == false)
                : <Category>[];
          }
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Отображаем выбранные теги (ингредиенты) как Chip
            buildSelectedTags(context, cocktailBloc, state, widget.step),
            const SizedBox(height: 24),
            Text(
              widget.step == 1
                  ? tr('cocktail_selection.step_base')
                  : tr('cocktail_selection.additional_ingredients'),
              style: context.text.bodyText16White,
            ),
            const SizedBox(height: 12),
            // Список категорий и ингредиентов
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return buildExpansionTile(
                    context,
                    cocktailBloc,
                    state,
                    widget.step,
                    category.name,
                    category.ingredients,
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

  Widget buildSelectedTags(
    BuildContext context,
    IngredientSelectionBloc cocktailBloc,
    IngredientSelectionState state,
    int sectionId,
  ) {
    final selectedItems = state.selectedItems[sectionId]?.entries
            .expand((entry) => entry.value)
            .toList() ??
        [];

    const int maxVisibleItems = 4;
    bool shouldShowMoreButton = selectedItems.length > maxVisibleItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 1.0,
          children:
              (showAll ? selectedItems : selectedItems.take(maxVisibleItems))
                  .map((item) {
            return Chip(
              backgroundColor: const Color(0xff3E3E3E),
              label: Text(
                item.name,
                style: context.text.bodyText14White,
              ),
              shape: const StadiumBorder(
                  side: BorderSide(color: Color(0xff343434))),
              deleteIcon: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xff3E3E3E),
                  size: 16,
                ),
              ),
              onDeleted: () {
                final category = state.selectedItems[sectionId]?.entries
                    .firstWhere((entry) => entry.value.contains(item))
                    .key;
                cocktailBloc
                    .add(ToggleSelectionEvent(sectionId, category!, item.name));
              },
            );
          }).toList(),
        ),
        if (shouldShowMoreButton)
          const SizedBox(
            height: 12,
          ),
        if (shouldShowMoreButton)
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    showAll
                        ? tr(
                            'cocktail_selection.hide') // Локализованное "Скрыть"
                        : tr('cocktail_selection.show_all'),
                    // Локализованное "Смотреть все"
                    style: context.text.bodyText16White
                        .copyWith(color: const Color(0xffB7B7B7)),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Color(0xffB7B7B7),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget buildExpansionTile(
      BuildContext context,
      IngredientSelectionBloc cocktailBloc,
      IngredientSelectionState state,
      int categoryId,
      String category,
      List<Ingredients> items,
      {bool isFirst = false,
      bool isLast = false}) {
    final ScrollController scrollController = ScrollController();

    // Получаем выбранные ингредиенты для данной категории и секции
    final selectedIngredients =
        state.selectedItems[categoryId]?[category] ?? [];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff343434)),
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(10.0) : Radius.zero,
          bottom: isLast ? Radius.circular(10.0) : Radius.zero,
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
                  style:
                      context.text.bodyText16White, // Стиль текста по умолчанию
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
                  bottom: isLast ? Radius.circular(10.0) : Radius.zero,
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
                      final selectedIngredients =
                          state.selectedItems[categoryId]?[category] ?? [];
                      return CustomCheckboxListTile(
                        title: item.name,
                        value: selectedIngredients.contains(item),
                        onChanged: (bool? selected) {
                          cocktailBloc.add(ToggleSelectionEvent(
                            widget.step, // ID секции (шаг)
                            category, // Имя категории
                            item.name,
                          ));
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
