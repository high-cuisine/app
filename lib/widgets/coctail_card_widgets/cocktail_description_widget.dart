import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CocktailDescriptionWidget extends StatelessWidget {
  const CocktailDescriptionWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        dividerColor: Colors.transparent,
        expansionTileTheme: const ExpansionTileThemeData(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          textAlign: TextAlign.start,
          tr("new_recipe.description"),
          style: context.text.bodyText16White.copyWith(fontSize: 18.0),
        ),
        expandedAlignment: Alignment.centerLeft,
        initiallyExpanded: false,
        collapsedIconColor: Colors.white,
        tilePadding: const EdgeInsets.all(0.0),
        children: [
          Text(
            textAlign: TextAlign.start,
            text,
            style: context.text.bodyText11Grey.copyWith(fontSize: 16.0),
          )
        ],
      ),
    );
  }
}
