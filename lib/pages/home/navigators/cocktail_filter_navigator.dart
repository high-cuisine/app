import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';

import '../cocktail_filter_steps/cocktail_filter_step_1.dart';
import '../cocktail_filter_steps/cocktail_filter_step_2.dart';
import '../cocktail_filter_steps/cocktail_filter_view.dart';

class CocktailFilterNavigator extends StatefulWidget {
  const CocktailFilterNavigator({
    super.key,
  });

  @override
  CocktailSelectionNavigatorState createState() =>
      CocktailSelectionNavigatorState();
}

class CocktailSelectionNavigatorState extends State<CocktailFilterNavigator> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swiping
      children: [
        CocktailFilterView(pageController: _pageController),
        CocktailFilterStep1(pageController: _pageController),
        CocktailFilterStep2(pageController: _pageController),
        // CocktailFilterStep3(pageController: _pageController),
      ],
    );
  }
}
