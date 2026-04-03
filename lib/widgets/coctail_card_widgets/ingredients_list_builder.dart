import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';
import '../../utilities/language_swich.dart';
import 'ingredients_list_card.dart';

class IngredientsListBuilder extends StatelessWidget {
  const IngredientsListBuilder({super.key, required this.cocktail});

  final Cocktail cocktail;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: LanguageService.getLanguage(), // Получаем текущий язык
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Показываем индикатор загрузки
        }

        if (snapshot.hasError) {
          return const Center(
              child: Text('Ошибка загрузки языка')); // Обработка ошибок
        }

        // Получаем текущий язык
        final currentLanguage = snapshot.data ?? 'rus';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              tr('ingredients_list.title'), // Локализованный заголовок
              overflow: TextOverflow.clip,
              style: context.text.bodyText16White.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF343434), width: 1.0),
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cocktail.ingredientCount,
                    itemBuilder: (context, index) {
                      final ingredient = cocktail.ingredients[index];

                      // Получаем переведенную единицу измерения
                      final translatedType =
                          ingredient.getTranslatedType(currentLanguage);

                      return IngredientsListCard(
                        type: translatedType, // Передаем переведенную единицу
                        title: ingredient.name,
                        count: ingredient.quantity,
                        border: index == cocktail.ingredientCount - 1
                            ? false
                            : true,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
