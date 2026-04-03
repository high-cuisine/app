import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';

class SelectedItemsWrap extends StatelessWidget {
  final bool isAlcoholic; // Флаг для фильтрации алкогольных ингредиентов

  const SelectedItemsWrap({super.key, required this.isAlcoholic});

  @override
  Widget build(BuildContext context) {
    // Получаем доступ к CocktailSelectionBloc
    final cocktailBloc = BlocProvider.of<CocktailSelectionBloc>(context);

    return BlocBuilder<CocktailSelectionBloc, CocktailSelectionState>(
      builder: (context, state) {
        // Фильтруем категории и ингредиенты в зависимости от флага isAlcoholic
        final selectedItems = state.selectedItems.entries
            .where((entry) {
              // Ищем категорию в секциях
              final categoryData = state.sections
                  .expand((section) => section.categories)
                  .firstWhere((cat) => cat.name == entry.key);

              // Проверяем, является ли категория алкогольной
              return isAlcoholic
                  ? categoryData.isAlcoholic
                  : !categoryData.isAlcoholic;
            })
            .expand((entry) => entry.value.map((item) => item))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedItems.isNotEmpty) ...[
              if (isAlcoholic)
                Text(tr("cocktail_selection.cocktail_base"),
                    // Локализация текста
                    style: context.text.bodyText16White)
              else
                Text(tr("cocktail_selection.additional_ingredients"),
                    style: context.text.bodyText16White),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Wrap(
                  children: selectedItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        backgroundColor: const Color(0xff3E3E3E),
                        label: Text(
                          item,
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
                        // Обработка удаления ингредиента
                        onDeleted: () {
                          final category = state.selectedItems.entries
                              .firstWhere((entry) => entry.value.contains(item))
                              .key;

                          // Determine which step this item belongs to
                          final isInStep1 =
                              state.step1Selections[category]?.contains(item) ??
                                  false;
                          final isInStep2 =
                              state.step2Selections[category]?.contains(item) ??
                                  false;

                          // Toggle from the appropriate step (prioritize Step 1 if in both)
                          if (isInStep1) {
                            cocktailBloc.add(
                                ToggleSelectionEvent(category, item, true));
                          } else if (isInStep2) {
                            cocktailBloc.add(
                                ToggleSelectionEvent(category, item, false));
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]
          ],
        );
      },
    );
  }
}
