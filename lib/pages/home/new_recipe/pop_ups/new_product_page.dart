import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../widgets/base_pop_up.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/home/create_cocktail_widgets/create_cocktail_chose_widget.dart';

class NewRecipeProductPage extends StatelessWidget {
  const NewRecipeProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("new_recipe.ingredients"),
      onPressed: null,
      arrow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Отображаем ингредиенты
          const NewCocktailView(step: 3),
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
