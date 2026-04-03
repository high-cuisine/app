import 'package:flutter/material.dart';

import '../navigators/cocktail_selection_navigator.dart';

void cocktailSelectionPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const SingleChildScrollView(child: CocktailSelectionNavigator());
    },
  );
}
