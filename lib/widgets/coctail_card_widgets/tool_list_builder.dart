import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/coctail_card_widgets/tool_list_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/cocktail_list_model.dart';

class ToolsListBuilder extends StatelessWidget {
  const ToolsListBuilder({super.key, required this.cocktail});

  final Cocktail cocktail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          tr('tools_list.title'), // Локализованный заголовок
          overflow: TextOverflow.clip,
          style: context.text.bodyText16White.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF343434), width: 1.0),
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cocktail.tools.length,
                itemBuilder: (context, index) => ToolsListCard(
                  tool: cocktail.tools[index],
                  border: index != cocktail.tools.length - 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
