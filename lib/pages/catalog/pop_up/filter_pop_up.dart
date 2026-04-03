import 'package:flutter/material.dart';

import '../navigator/filter_navigator.dart';

void openFilterModal(BuildContext context, bool isAlcoholic) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SingleChildScrollView(
        child: FilterNavigator(
          catalogPage: isAlcoholic,
        ),
      );
    },
  );
}
