import 'package:flutter/material.dart';

import '../navigators/cocktail_filter_navigator.dart';

void cocktailFilterPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const SingleChildScrollView(child: CocktailFilterNavigator());
    },
  );
}
