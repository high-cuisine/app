import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/home/animaited_loading.dart';
import '../../../widgets/home/step_indicator.dart';

class CocktailSelectionStep3 extends StatefulWidget {
  final PageController pageController;

  const CocktailSelectionStep3({super.key, required this.pageController});

  @override
  CocktailSelectionStep3State createState() => CocktailSelectionStep3State();
}

class CocktailSelectionStep3State extends State<CocktailSelectionStep3> {
  @override
  Widget build(BuildContext context) {
    return BasePopup(
      text: tr("cocktail_selection_page.cocktail_selection"),
      onPressed: null,
      arrow: false,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepIndicator(
            activeStep: 2,
          ),
          SizedBox(height: 50),
          AnimatedProgressBarPage(),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
