import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';

import '../permission_page.dart';
import '../registration_page_1.dart';
import '../registration_page_2.dart';
import '../registration_page_3.dart';
import '../registration_page_4.dart';

class RegistrationNavigator extends StatefulWidget {
  final PageController mainPageController;

  const RegistrationNavigator({super.key, required this.mainPageController});

  @override
  RegistrationNavigatorState createState() => RegistrationNavigatorState();
}

class RegistrationNavigatorState extends State<RegistrationNavigator> {
  final PageController _pageController = PageController();

  String _email = '';
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _gender = '';
  String _dateOfBirth = '';
  String _promoCode = '';

  @override
  Widget build(BuildContext context) {
    return ExpandablePageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swiping
      children: [
        RegistrationPage1(
          pageController: _pageController,
          mainPageController: widget.mainPageController,
          onEmailEntered: setEmail,
        ),
        RegistrationPage2(
          pageController: _pageController,
          email: _email,
        ),
        RegistrationPage3(
          pageController: _pageController,
          email: _email,
          onPersonalInfoEntered: setPersonalInfo,
        ),
        RegistrationPage4(
          pageController: _pageController,
          email: _email,
          firstName: _firstName,
          lastName: _lastName,
          phone: _phone,
          gender: _gender,
          dateOfBirth: _dateOfBirth,
          referralCode: _promoCode,
        ),
        RegistrationPage5(
          pageController: _pageController,
        ),
      ],
    );
  }

  void setEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void setPersonalInfo(
    String firstName,
    String lastName,
    String phone,
    String gender,
    String dateOfBirth,
    String promoCode,
  ) {
    setState(() {
      _firstName = firstName;
      _lastName = lastName;
      _phone = phone;
      _gender = gender;
      _dateOfBirth = dateOfBirth;
      _promoCode = promoCode;
    });
  }
}
