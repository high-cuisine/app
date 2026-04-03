import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';

class SelectedItemsCarousel extends StatelessWidget {
  const SelectedItemsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем доступ к CocktailSelectionBloc
    final cocktailBloc = BlocProvider.of<CocktailSelectionBloc>(context);

    return BlocBuilder<CocktailSelectionBloc, CocktailSelectionState>(
      builder: (context, state) {
        // Извлекаем выбранные элементы из состояния блока
        final selectedItems = state.selectedItems.entries
            .expand((entry) => entry.value.map((item) => item))
            .toList();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
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
                    // Обработка удаления ингредиента
                    onDeleted: () {
                      // Находим категорию, к которой относится элемент
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
                        cocktailBloc
                            .add(ToggleSelectionEvent(category, item, true));
                      } else if (isInStep2) {
                        cocktailBloc
                            .add(ToggleSelectionEvent(category, item, false));
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
