import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_button.dart';
import 'auth/popups/auth_pop_up.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _skipWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const CustomBottomNavigationBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomButton(
                        text: tr("buttons.skip"),
                        transper: true,
                        onPressed: _skipWelcome,
                        single: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: CustomButton(
                        text: tr("sign_in_page.title"),
                        onPressed: () {
                          authPopUp(context);
                        },
                        single: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/auth_background.jpeg'),
          fit: BoxFit
              .cover, // This property ensures the image covers the whole screen
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 94.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/images/logo_full.png',
          ),
        ),
      ),
    );
  }
}
