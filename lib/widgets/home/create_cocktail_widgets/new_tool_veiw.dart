import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/create_cocktail_bloc/create_cocktail_bloc.dart';
import '../../../models/cocktail_list_model.dart';
import '../../custom_checkbox.dart';

class NewToolView extends StatefulWidget {
  const NewToolView({super.key});

  @override
  NewToolViewState createState() => NewToolViewState();
}

class NewToolViewState extends State<NewToolView> {
  @override
  void initState() {
    super.initState();
    context
        .read<CocktailCreationBloc>()
        .add(LoadToolsEvent()); // Загрузка инструментов
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

        // Инструменты, полученные из состояния
        List<Tool> tools = state.tools;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSelectedToolsTable(context, cocktailBloc, state),
            const SizedBox(height: 24),
            const SizedBox(height: 12),
            buildExpansionTile(context, cocktailBloc, state, tools),
          ],
        );
      },
    );
  }

  // Таблица для отображения выбранных инструментов
  Widget buildSelectedToolsTable(
    BuildContext context,
    CocktailCreationBloc cocktailBloc,
    CocktailCreationState state,
  ) {
    final selectedTools = state.selectedTools;

    if (selectedTools.isEmpty) {
      return Container();
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: selectedTools.map((tool) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF343434), width: 1),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.02),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: Center(
                            child: Text(
                              tool.name,
                              style: context.text.bodyText14White
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                // Удаление инструмента из списка
                cocktailBloc.add(RemoveToolEvent(tool));
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
          ],
        );
      }).toList(),
    );
  }

  // Отображение инструментов в виде ExpansionTile, аналогично как с ингредиентами
  Widget buildExpansionTile(
    BuildContext context,
    CocktailCreationBloc cocktailBloc,
    CocktailCreationState state,
    List<Tool> tools,
  ) {
    final ScrollController scrollController = ScrollController();

    // Выбранные инструменты
    final selectedTools = state.selectedTools;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff343434)),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                  text: '${tr("new_recipe.tools")}  ',
                  style: context.text.bodyText16White, // Стиль текста
                ),
                TextSpan(
                  text:
                      '(${selectedTools.length} ${tr('cocktail_selection.selected')})',
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
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10.0),
                ),
              ),
              child: SizedBox(
                height: 150, // Ограничиваем высоту виджета
                child: Scrollbar(
                  radius: const Radius.circular(30),
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 4,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: tools.length,
                    itemBuilder: (context, index) {
                      final tool = tools[index];
                      // Проверяем наличие инструмента по id, а не по объекту целиком
                      final isSelected = selectedTools
                          .any((selectedTool) => selectedTool.id == tool.id);

                      return CustomCheckboxListTile(
                        title: tool.name,
                        value: isSelected, // Устанавливаем значение флажка
                        onChanged: (bool? selected) {
                          if (selected == true) {
                            cocktailBloc.add(AddToolEvent(tool));
                          } else {
                            cocktailBloc.add(RemoveToolEvent(tool));
                          }
                        },
                      );
                    },
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
