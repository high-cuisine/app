import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cocktail_list_bloc/cocktail_list_bloc.dart';
import '../custom_checkbox.dart';

class SortExpansionTile extends StatefulWidget {
  final String currentSortOption;
  final ValueChanged<String>? onSortChanged;

  const SortExpansionTile({
    required this.currentSortOption,
    this.onSortChanged,
    super.key,
  });

  @override
  SortExpansionTileState createState() => SortExpansionTileState();
}

class SortExpansionTileState extends State<SortExpansionTile> {
  late String selectedSortOption;

  // Эти названия должны быть синхронизированы с API-параметрами
  final List<Map<String, String>> sortOptions = [
    {
      'label': 'catalog_page.sort_by_popularity',
      'apiField': '-popularity',
    },
    {
      'label': 'catalog_page.sort_alphabet_asc',
      'apiField': 'title',
    },
    {
      'label': 'catalog_page.sort_alphabet_desc',
      'apiField': '-title',
    },
    {
      'label': 'catalog_page.sort_by_video',
      'apiField': 'video_url',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Инициализируем выбранную сортировку из переданного параметра
    selectedSortOption = widget.currentSortOption;
  }

  // Получаем отображаемый заголовок для текущей сортировки
  String _getSortTitle() {
    final selectedOption = sortOptions.firstWhere(
      (option) => option['apiField'] == selectedSortOption,
      orElse: () => sortOptions.first,
    );
    return tr(selectedOption['label']!); // Локализация для текущей сортировки
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff343434)),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10.0),
          bottom: Radius.circular(10.0),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Убираем разделитель
        ),
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Text(
              _getSortTitle(), // Отображаем текущий заголовок сортировки
              style: context.text.bodyText16White,
            ),
          ),
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 7.0),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10.0),
                ),
              ),
              child: SizedBox(
                height: 150, // Ограничиваем высоту виджета
                child: ListView.builder(
                  itemCount: sortOptions.length,
                  itemBuilder: (context, index) {
                    final option = sortOptions[index];
                    return CustomCheckboxListTile(
                      title: tr(option['label']!), // Локализуем заголовок
                      value: selectedSortOption == option['apiField'],
                      // Устанавливаем галочку на текущем выбранном значении
                      onChanged: (bool? selected) {
                        if (selected == true) {
                          final newSort = option['apiField']!;
                          setState(() {
                            selectedSortOption = newSort;
                          });
                          if (widget.onSortChanged != null) {
                            widget.onSortChanged!(newSort);
                          } else {
                            context.read<CocktailListBloc>().add(
                                  SearchCocktails(ordering: newSort),
                                );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
