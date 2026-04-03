import 'package:flutter/material.dart';
import '../navigators/auth_navigator.dart';

void authPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const SingleChildScrollView(child: AuthPageView());
    },
  );
}
