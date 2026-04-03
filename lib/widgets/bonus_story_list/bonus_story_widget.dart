import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/bonus_story_list/bonus_story_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BonusStoryWidget extends StatefulWidget {
  const BonusStoryWidget({super.key});

  @override
  State<BonusStoryWidget> createState() => _BonusStoryWidgetState();
}

class _BonusStoryWidgetState extends State<BonusStoryWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              tr('bonus_screen.history'), // Локализуем заголовок
              textAlign: TextAlign.start,
              style:
                  context.text.buttonText18Brown.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF343434), width: 1.0),
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: jsonExample.length,
                  itemBuilder: (context, index) => BonusStoryCard(
                      title: jsonExample[index]["title"],
                      count: jsonExample[index]["count"],
                      border: index == jsonExample.length - 1 ? false : true),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> jsonExample = [
    {
      "title": "Приготовление коктейля",
      "count": 15,
    },
    {
      "title": "Обмен баллов",
      "count": -15,
    },
    {
      "title": "Приготовление коктейля",
      "count": 15,
    },
    {
      "title": "Создание рецепта",
      "count": 15,
    },
    {
      "title": "Приготовление коктейля",
      "count": 15,
    },
  ];
}
