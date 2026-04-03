import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InfoTileAccount extends StatelessWidget {
  final String icon;
  final String title;
  final Function()? onTap;

  const InfoTileAccount({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Center(
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff2B2B2B),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
              ),
            ),
          ),
          title: Text(
            title,
            style: context.text.buttonText18Brown.copyWith(color: Colors.white),
          ),
          trailing: Container(
            width: 30,
            height: 30,
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
              onPressed: onTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 24.0,
              tooltip: 'Back',
            ),
          ),
        ),
      ),
    );
  }
}
