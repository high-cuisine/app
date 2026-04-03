import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../widgets/base_pop_up.dart';

void userAgreementPopUp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: tr('about_app.terms_of_use'), // Локализация заголовка
        onPressed: () {
          Navigator.pop(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                child: Text(
                  tr('policy.user_agreement'),
                  textAlign: TextAlign.center,
                  style: context.text.bodyText16White
                      .copyWith(color: Colors.white.withOpacity(0.85)),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      );
    },
  );
}
