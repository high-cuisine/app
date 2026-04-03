import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangeCocktailTile extends StatelessWidget {
  final String name;
  final bool border;
  final Function()? onTap;
  final int selectedCount;

  const ChangeCocktailTile({
    super.key,
    this.border = true,
    required this.name,
    this.selectedCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onTap!();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: ListTile(
              title: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$name  ',
                      style: context
                          .text.bodyText16White, // Стиль текста по умолчанию
                    ),
                    TextSpan(
                      text: selectedCount > 0
                          ? '($selectedCount ${tr('cocktail_selection.selected')})'
                          : '',
                      // Здесь будет ваше время
                      style: context.text.bodyText12Grey
                          .copyWith(fontSize: 16 // Измените цвет на нужный вам
                              ),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/arrow_forward.svg',
                    width: 10,
                    height: 10,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  iconSize: 30.0,
                  onPressed: () {
                    onTap!();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 24.0,
                  tooltip: 'Подробнее',
                ),
              ),
            ),
          ),
        ),
        if (border) const Divider(color: Color(0xff343434), height: 1),
      ],
    );
  }
}
