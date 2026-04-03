import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_setup_bloc/cocktail_setup_bloc.dart';
import '../custom_checkbox.dart';

class CocktailSelectionView extends StatefulWidget {
  final bool
      step; // Это флаг, чтобы знать, какой шаг мы показываем: алкогольный или безалкогольный

  const CocktailSelectionView({super.key, required this.step});

  @override
  CocktailSelectionViewState createState() => CocktailSelectionViewState();
}

class CocktailSelectionViewState extends State<CocktailSelectionView> {
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    // Шаг 1 и шаг 2: сначала просто загружаем все ингредиенты,
    // а разделение на алкогольные/безалкогольные делаем на клиенте.
    context.read<CocktailSelectionBloc>().add(LoadCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = BlocProvider.of<CocktailSelectionBloc>(context);

    return BlocBuilder<CocktailSelectionBloc, CocktailSelectionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          print("Ошибка: ${state.errorMessage}");
          return Center(
            child: Text(tr("errors.error"),
                style: const TextStyle(color: Colors.red)),
          );
        }

        final sections = state.sections;

        // Фильтруем категории по составу ингредиентов:
        // widget.step == true  → база (алкогольные ингредиенты)
        // widget.step == false → дополнительные (безалкогольные ингредиенты)
        final categories = sections.expand((section) {
          return section.categories.where((category) {
            final hasAlcoholic =
                category.ingredients.any((ing) => ing.isAlcoholic);
            final hasNonAlcoholic =
                category.ingredients.any((ing) => !ing.isAlcoholic);
            return widget.step ? hasAlcoholic : hasNonAlcoholic;
          });
        }).toList();

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSelectedTags(context, cocktailBloc, state),
            const SizedBox(height: 24),
            Text(
              widget.step
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
                  return buildExpansionTile(
                    context,
                    cocktailBloc,
                    state,
                    category.name,
                    category.ingredients
                        .map((ingredients) => ingredients.name)
                        .toList(),
                    isFirst: index == 0,
                    isLast: index == categories.length - 1,
                    step: widget.step,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildSelectedTags(BuildContext context,
      CocktailSelectionBloc cocktailBloc, CocktailSelectionState state) {
    final selectedItems = state.selectedItems.entries
        .expand((entry) => entry.value.map((item) => item))
        .toList();

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
              onDeleted: () {
                final category = state.selectedItems.entries
                    .firstWhere((entry) => entry.value.contains(item))
                    .key;
                // Determine which step this item belongs to
                final isInStep1 =
                    state.step1Selections[category]?.contains(item) ?? false;
                final isInStep2 =
                    state.step2Selections[category]?.contains(item) ?? false;

                // Toggle from the appropriate step (prioritize Step 1 if in both)
                if (isInStep1) {
                  cocktailBloc.add(ToggleSelectionEvent(category, item, true));
                } else if (isInStep2) {
                  cocktailBloc.add(ToggleSelectionEvent(category, item, false));
                }
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
      CocktailSelectionBloc cocktailBloc,
      CocktailSelectionState state,
      String category,
      List<String> items,
      {bool isFirst = false,
      bool isLast = false,
      required bool step}) {
    final ScrollController scrollController = ScrollController();

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
                  style:
                      context.text.bodyText16White, // Стиль текста по умолчанию
                ),
                TextSpan(
                  text:
                      '(${state.selectedItems[category]?.length ?? 0} ${tr('cocktail_selection.selected')})',
                  // Здесь будет ваше время
                  style: context.text.bodyText12Grey
                      .copyWith(fontSize: 16 // Измените цвет на нужный вам
                          ),
                ),
              ],
            ),
          ),
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
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
                      return CustomCheckboxListTile(
                        title: item,
                        value: state.selectedItems[category]?.contains(item) ??
                            false,
                        onChanged: (bool? selected) {
                          cocktailBloc
                              .add(ToggleSelectionEvent(category, item, step));
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
