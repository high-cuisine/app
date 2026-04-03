import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class IngredientsListCard extends StatelessWidget {
  const IngredientsListCard(
      {super.key,
      required this.title,
      required this.count,
      required this.type,
      required this.border});

  final String title;
  final String type;
  final String count;
  final bool border;

  String formatCount(String count) {
    final double? value = double.tryParse(count);
    if (value != null && value == value.toInt()) {
      // Если число целое, выводим его без десятичных знаков
      return value.toInt().toString();
    }
    // В противном случае выводим исходное число
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.text.headline20White
                    .copyWith(color: Colors.white, fontSize: 15.0),
              ),
              Text("${formatCount(count)} $type",
                  style: context.text.headline20White.copyWith(
                      color: const Color(0xFFB7B7B7), fontSize: 15.0)),
            ],
          ),
        ),
        border
            ? const Divider(
                color: Color(0xFF343434),
                height: 1.0,
              )
            : const SizedBox()
      ],
    );
  }
}
