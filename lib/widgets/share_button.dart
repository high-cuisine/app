import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ShareButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/images/share_icon.svg',
        width: 22,
        height: 22,
      ),
      iconSize: 30.0,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 24.0,
      tooltip: 'Back',
    );
  }
}
