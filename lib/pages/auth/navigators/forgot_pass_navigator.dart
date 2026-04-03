import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';

import '../forgot_pass_page_1.dart';
import '../forgot_pass_page_2.dart';
import '../forgot_pass_page_3.dart';

class ForgotPassNavigator extends StatefulWidget {
  final PageController mainPageController;

  const ForgotPassNavigator({super.key, required this.mainPageController});

  @override
  ForgotPassNavigatorState createState() => ForgotPassNavigatorState();
}

class ForgotPassNavigatorState extends State<ForgotPassNavigator> {
  final PageController _pageController = PageController();
  String _email = '';
  String _code = '';

  void _setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void _setCode(String code) {
    setState(() {
      _code = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swiping
      children: [
        ForgotPassPage1(
          pageController: _pageController,
          mainPageController: widget.mainPageController,
          onEmailEntered: (email) {
            _setEmail(email);
          },
        ),
        ForgotPassPage2(
            pageController: _pageController,
            email: _email,
            onCodeEntered: (code) {
              print('Code saved: $code');
              _setCode(code);
            }),
        ForgotPassPage3(
          pageController: _pageController,
          email: _email,
          code: _code,
        ),
      ],
    );
  }
}
