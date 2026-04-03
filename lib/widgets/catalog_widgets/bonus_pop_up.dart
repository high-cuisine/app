import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../base_pop_up.dart';
import '../custom_button.dart';

void bonusTakePopUp(BuildContext context, name) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: tr('catalog_page.bonus_take_title'), // Локализация заголовка
        onPressed: () {
          Navigator.pop(context);
        },
        arrow: false,
        child: Column(
          children: [
            Text(
              tr('catalog_page.bonus_take_subtitle',
                  namedArgs: {'name': name.toString()}),
              // Локализация текста
              style: context.text.bodyText12Grey
                  .copyWith(fontSize: 16, height: 1.5),
            ),
            const SizedBox(
              height: 24,
            ),
            CustomButton(
              text: tr('catalog_page.good'),
              // Локализация кнопки
              single: true,
              onPressed: () {
                Navigator.pop(context);
              },
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
