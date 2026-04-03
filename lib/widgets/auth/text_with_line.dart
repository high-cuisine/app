import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class TextWithLines extends StatelessWidget {
  final String text;
  final double lineThickness;
  final Color lineColor;

  const TextWithLines({
    super.key,
    required this.text,
    this.lineThickness = 1.0,
    this.lineColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: lineThickness,
            color: lineColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: context.text.bodyText12Grey.copyWith(fontSize: 14.0),
          ),
        ),
        Expanded(
          child: Container(
            height: lineThickness,
            color: lineColor,
          ),
        ),
      ],
    );
  }
}
