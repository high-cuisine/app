import 'package:cocktails/models/store_model.dart';
import 'package:cocktails/pages/store/popups/product_page.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String? price;
  final Product product; // Передаем весь продукт для переходов

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      height: 120,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 11.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(11)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey,
                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.text.headline24White.copyWith(fontSize: 16),
                  maxLines: 2, // Ограничиваем двумя строками
                  overflow: TextOverflow.ellipsis, // Обрезаем и добавляем "..."
                ),
                const SizedBox(height: 4),
                Text(
                  tr('store.price_from', namedArgs: {'count': price ?? '0'}),
                  // Локализованная строка
                  style: context.text.bodyText12Grey.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SizedBox(
                    height: 41.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.06),
                        side: BorderSide(
                            color: const Color(0xffF6B402).withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 2),
                      ),
                      onPressed: () {
                        productPagePopUp(context, product);
                      },
                      child: Text(
                        tr('store.order_now'), // Локализованная строка
                        style: context.text.bodyText14White,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
