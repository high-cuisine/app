import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_arrowback.dart';

class TermsUsePage extends StatelessWidget {
  const TermsUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            CustomAppBar(
              text: tr('about_app.terms_of_use'),
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
                  tr('policy.user_agreement'),
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
