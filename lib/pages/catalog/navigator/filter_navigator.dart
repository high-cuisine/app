import 'package:flutter/material.dart';

import '../filter_pages/filter_page.dart';

class FilterNavigator extends StatelessWidget {
  final bool catalogPage;

  const FilterNavigator({super.key, required this.catalogPage});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => FilterMainPage(catalogPage: catalogPage),
          );
        },
      ),
    );
  }
}
