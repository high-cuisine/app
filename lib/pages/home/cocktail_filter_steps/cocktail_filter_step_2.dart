import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/home/cocktail_selection_widget.dart';
import '../../../widgets/home/step_indicator.dart';

class CocktailFilterStep2 extends StatefulWidget {
  final PageController pageController;

  const CocktailFilterStep2({super.key, required this.pageController});

  @override
  CocktailFilterStep2State createState() => CocktailFilterStep2State();
}

class CocktailFilterStep2State extends State<CocktailFilterStep2> {
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
            activeStep: 1,
            thirdStep: false,
          ),
          const CocktailSelectionView(
            step: false,
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
                      widget.pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    single: false,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: CustomButton(
                    gradient: true,
                    text: tr("cocktail_selection_page.choose"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    single: false,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
