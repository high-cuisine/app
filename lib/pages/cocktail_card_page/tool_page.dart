import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/store/expandable_text.dart';

void toolPagePopUp(BuildContext context, Tool tool) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BasePopup(
        text: tool.name ?? tr('store.default_product_name'),
        // Локализованная строка
        onPressed: () {
          Navigator.pop(context);
        },
        child: SafeArea(
          child: Column(
            children: [
              // ClipRRect(
              //   borderRadius: const BorderRadius.all(Radius.circular(11)),
              //   child: AspectRatio(
              //     aspectRatio: 1,
              //     child: (tool.photo != null && tool.photo!.isNotEmpty)
              //         ? Image.network(
              //             tool.photo!,
              //             fit: BoxFit.cover,
              //             errorBuilder: (context, error, stackTrace) {
              //               // Показываем контейнер, если загрузка изображения не удалась
              //               return Container(
              //                 width: double.infinity,
              //                 height: 190,
              //                 color: Colors.grey,
              //                 child: const Icon(
              //                   Icons.broken_image,
              //                   color: Colors.white,
              //                   size: 50,
              //                 ),
              //               );
              //             },
              //           )
              //         : Container(
              //             width: double.infinity,
              //             height: 190,
              //             color: Colors.grey,
              //             child: const Icon(
              //               Icons.image,
              //               color: Colors.white,
              //               size: 50,
              //             ),
              //           ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 24,
              // ),
              // Проверка на null и пустую строку для описания
              ExpandableTextWidget(
                text: (tool.description != null && tool.description!.isNotEmpty)
                    ? tool.description!
                    : tr('store.no_description'),
                titleText: tr('store.description'), // Локализованная строка
              ),
              const SizedBox(
                height: 24,
              ),
              // Проверка на null и пустую строку для инструкции по использованию
              ExpandableTextWidget(
                text: (tool.howToUse != null && tool.howToUse!.isNotEmpty)
                    ? tool.howToUse!
                    : tr('store.no_description'),
                titleText: tr('store.how_to_use'), // Локализованная строка
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      );
    },
  );
}
