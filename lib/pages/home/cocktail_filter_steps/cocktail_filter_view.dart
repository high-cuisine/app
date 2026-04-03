import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../widgets/base_pop_up.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/home/selected_item_wrap.dart';

class CocktailFilterView extends StatefulWidget {
  final PageController pageController;

  const CocktailFilterView({super.key, required this.pageController});

  @override
  CocktailFilterViewState createState() => CocktailFilterViewState();
}

class CocktailFilterViewState extends State<CocktailFilterView> {
  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("cocktail_selection.current_selection"),
      onPressed: null,
      arrow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("cocktail_selection.description"),
            style: context.text.bodyText12Grey.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          const SelectedItemsWrap(isAlcoholic: true),
          const SelectedItemsWrap(isAlcoholic: false),
          const SizedBox(height: 20),
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
                    text: tr("buttons.change"),
                    gradient: true,
                    onPressed: () {
                      widget.pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    single: false,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
