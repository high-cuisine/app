import 'package:cocktails/models/store_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/auth/custom_registration_button.dart';
import '../../../widgets/base_pop_up.dart';
import '../../../widgets/store/expandable_text.dart';

void productPagePopUp(BuildContext context, Product product) {
  showCupertinoModalBottomSheet(
    context: context,
    isDismissible: true,
    enableDrag: true,
    expand: false,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: product.name ?? tr('store.default_product_name'),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(11)),
              child: AspectRatio(
                aspectRatio: 1,
                child: product.photo != null
                    ? Image.network(
                        product.photo!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 190,
                        color: Colors.grey,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            ExpandableTextWidget(
              text: product.description ?? "Нет описания",
              titleText: tr('store.description'),
            ),
            const SizedBox(height: 24),
            if (product.link != null && product.link!.isNotEmpty)
              Column(
                children: [
                  RegistrationServicesButton(
                    text: tr('store.buy_on', namedArgs: {
                      'count': _detectMarketplace(product.link!)
                    }),
                    trailingText: '',
                    onPressed: () {
                      launchUrl(Uri.parse(product.link!));
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}

String _detectMarketplace(String link) {
  if (link.contains('wildberries')) {
    return 'Wildberries';
  } else if (link.contains('ozon')) {
    return 'Ozon';
  } else if (link.contains('yandex')) {
    return tr('store.marketplace_yandex');
  }
  return 'Магазин';
}
