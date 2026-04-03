import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_arrowback.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            CustomAppBar(
              text: tr('about_app.privacy_policy'),
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  tr('policy.privacy_policy'),
                  textAlign: TextAlign.center,
                  style: context.text.bodyText16White
                      .copyWith(color: Colors.white.withOpacity(0.85)),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
