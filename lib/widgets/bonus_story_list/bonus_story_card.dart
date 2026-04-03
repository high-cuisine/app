import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BonusStoryCard extends StatelessWidget {
  const BonusStoryCard(
      {super.key,
      required this.title,
      required this.count,
      required this.border});

  final String title;
  final int count;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr(title), // Локализуем заголовок
                style: context.text.headline20White
                    .copyWith(color: Colors.white, fontSize: 15.0),
              ),
              Text(
                  count > 0
                      ? "+$count ${tr('bonus_screen.points')}"
                      : "$count ${tr('bonus_screen.points')}",
                  // Локализуем текст с баллами
                  style: count > 0
                      ? context.text.headline20White.copyWith(
                          color: const Color(0xFF68C248), fontSize: 15.0)
                      : context.text.headline20White.copyWith(
                          color: const Color(0xFFFF4747), fontSize: 15.0)),
            ],
          ),
        ),
        border
            ? const Divider(
                color: Color(0xFF343434),
                height: 1.0,
              )
            : const SizedBox(),
      ],
    );
  }
}
