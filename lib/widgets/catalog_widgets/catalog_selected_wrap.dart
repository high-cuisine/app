import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/catalog_filter_bloc/catalog_filter_bloc.dart';

class CatalogSelectedItemsWrap extends StatefulWidget {
  const CatalogSelectedItemsWrap({super.key});

  @override
  State<CatalogSelectedItemsWrap> createState() =>
      _CatalogSelectedItemsWrapState();
}

class _CatalogSelectedItemsWrapState extends State<CatalogSelectedItemsWrap> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = BlocProvider.of<IngredientSelectionBloc>(context);

    return BlocBuilder<IngredientSelectionBloc, IngredientSelectionState>(
      builder: (context, state) {
        // Собираем все выбранные ингредиенты из всех секций и категорий
        final selectedItems =
            state.selectedItems.entries.expand((sectionEntry) {
          return sectionEntry.value.entries.expand((categoryEntry) {
            return categoryEntry.value.map((item) => {
                  'sectionId': sectionEntry.key,
                  'category': categoryEntry.key,
                  'ingredient': item.name
                });
          });
        }).toList();

        const int maxVisibleItems = 7;
        bool shouldShowMoreButton = selectedItems.length > maxVisibleItems;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 1.0,
              children: (showAll
                      ? selectedItems
                      : selectedItems.take(maxVisibleItems))
                  .map((itemData) {
                final sectionId = itemData['sectionId'] as int;
                final category = itemData['category'] as String;
                final ingredient = itemData['ingredient'] as String;

                return Chip(
                  backgroundColor: const Color(0xff3E3E3E),
                  label: Text(
                    ingredient,
                    style: context.text.bodyText14White,
                  ),
                  shape: const StadiumBorder(
                    side: BorderSide(color: Color(0xff343434)),
                  ),
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
                    // Удаление ингредиента с указанием секции и категории
                    cocktailBloc.add(
                        ToggleSelectionEvent(sectionId, category, ingredient));
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
                        // Локализованное "Показать все"
                        style: context.text.bodyText16White.copyWith(
                          color: const Color(0xffB7B7B7),
                        ),
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
      },
    );
  }
}
