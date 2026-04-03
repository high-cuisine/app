import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';

import '../cocktail_selection_steps/cocktail_selection_step_1.dart';
import '../cocktail_selection_steps/cocktail_selection_step_2.dart';
import '../cocktail_selection_steps/cocktail_selection_step_3.dart';

class CocktailSelectionNavigator extends StatefulWidget {
  const CocktailSelectionNavigator({
    super.key,
  });

  @override
  CocktailSelectionNavigatorState createState() =>
      CocktailSelectionNavigatorState();
}

class CocktailSelectionNavigatorState
    extends State<CocktailSelectionNavigator> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swiping
      children: [
        CocktailSelectionStep1(pageController: _pageController),
        CocktailSelectionStep2(pageController: _pageController),
        CocktailSelectionStep3(pageController: _pageController),
      ],
    );
  }
}
