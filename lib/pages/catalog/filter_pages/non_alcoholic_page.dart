import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../widgets/base_pop_up.dart';
import '../../../widgets/catalog_widgets/cocktail_filter_widget.dart';
import '../../../widgets/custom_button.dart';

class NonAlcoholicPage extends StatefulWidget {
  const NonAlcoholicPage({super.key});

  @override
  State<NonAlcoholicPage> createState() => _NonAlcoholicPageState();
}

class _NonAlcoholicPageState extends State<NonAlcoholicPage> {
  @override
  void initState() {
    super.initState();

    // Запрашиваем категории (алкогольные напитки)
  }

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("new_recipe.non_alcoholic_drinks"),
      onPressed: null,
      arrow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Добавляем выбранные ингредиенты в виде Chip
          const CocktailFilterView(
            step: 2,
          ),
          const SizedBox(
            height: 24,
          ),
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
                      Navigator.pop(context);
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
                      Navigator.pop(context);
                    },
                    single: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
