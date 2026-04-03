import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PermissionWidget extends StatelessWidget {
  final String headLineText;
  final String text;
  final String svg;

  const PermissionWidget({
    super.key,
    required this.text,
    required this.headLineText,
    required this.svg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff2B2B2B),
          ),
          child: Center(
            child: SvgPicture.asset(
              svg,
              width: 17,
              height: 17,
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headLineText,
              style: context.text.bodyText16White,
            ),
            Text(
              text,
              style: context.text.bodyText12Grey.copyWith(fontSize: 14),
            )
          ],
        )
      ],
    );
  }
}
