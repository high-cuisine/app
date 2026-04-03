import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

PreferredSizeWidget baseAppBar(
  BuildContext context,
  String title,
  bool actions,
  bool arrowBack,
) {
  return AppBar(
    leadingWidth: 50,
    toolbarHeight: 70,
    titleSpacing: 8,
    elevation: 0,
    leading: arrowBack
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: SvgPicture.asset(
                    'assets/images/arrow_back.svg',
                    width: 10,
                    height: 10,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox(),
    title: Text(
      title,
      style: context.text.headline24White,
      overflow: TextOverflow.ellipsis,
    ),
    actions: [
      if (actions)
        IconButton(
          icon: SvgPicture.asset(
            'assets/images/filter_icon.svg',
            color: Colors.white,
          ),
          onPressed: () {
            print('dsa');
          },
        )
    ],
  );
}
