import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CocktailInstructionCard extends StatelessWidget {
  const CocktailInstructionCard({
    super.key,
    required this.index,
    required this.text,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            textAlign: TextAlign.start,
            tr('cocktail_instructions.step',
                namedArgs: {'step': index.toString()}),
            style: context.text.bodyText14White.copyWith(
              fontSize: 15.0,
              color: const Color(0xFFF6B402),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            text,
            style: context.text.headline20White.copyWith(fontSize: 15.0),
          ),
        ],
      ),
    );
  }
}
