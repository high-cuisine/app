import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AboutAppTile extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool version;

  const AboutAppTile({
    super.key,
    required this.title,
    required this.onTap,
    this.version = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Center(
        child: ListTile(
            onTap: onTap,
            title: Text(
              title,
              style:
                  context.text.buttonText18Brown.copyWith(color: Colors.white),
            ),
            trailing: version
                ? Container(
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
                  )
                : Text(
                    'v 1.0',
                    style: context.text.bodyText12Grey.copyWith(fontSize: 15),
                  )),
      ),
    );
  }
}
