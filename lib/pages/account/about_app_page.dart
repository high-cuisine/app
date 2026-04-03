import 'package:cocktails/pages/account/privacy_policy_page.dart';
import 'package:cocktails/pages/account/terms_use_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../widgets/account/about_app_tile.dart';
import '../../widgets/custom_arrowback.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            CustomAppBar(
              text: tr('about_app.title'),
              // Локализованный заголовок "О приложении"
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 42,
            ),
            Card(
              color: Colors.white.withOpacity(0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color(0xff343434),
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  AboutAppTile(
                    title: tr('about_app.privacy_policy'),
                    // Локализованная строка "Политика конфиденциальности"
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage()));
                    },
                  ),
                  const Divider(color: Color(0xff343434), height: 1),
                  AboutAppTile(
                    title: tr('about_app.terms_of_use'),
                    // Локализованная строка "Пользовательское соглашение"
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TermsUsePage()));
                    },
                  ),
                  const Divider(color: Color(0xff343434), height: 1),
                  AboutAppTile(
                    title: tr('about_app.app_version'),
                    // Локализованная строка "Версия приложения"
                    onTap: () {},
                    version: false,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
