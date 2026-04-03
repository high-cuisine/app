import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/home/cocktail_selection_widget.dart';
import '../../../widgets/home/step_indicator.dart';

class CocktailSelectionStep1 extends StatefulWidget {
  final PageController pageController;

  const CocktailSelectionStep1({super.key, required this.pageController});

  @override
  CocktailSelectionStep1State createState() => CocktailSelectionStep1State();
}

class CocktailSelectionStep1State extends State<CocktailSelectionStep1> {
  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("cocktail_selection_page.cocktail_selection"),
      onPressed: null,
      arrow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepIndicator(
            activeStep: 0,
          ),
          const CocktailSelectionView(
            step: true,
          ),
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
                    text: tr("buttons.choose"),
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
