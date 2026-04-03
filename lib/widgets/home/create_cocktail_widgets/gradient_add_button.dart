import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GradientAddButton extends StatelessWidget {
  final Function() onTap;

  const GradientAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFFF8C82C),
            Color(0xFFEF7F31),
            Color(0xFFDD66A9),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/images/krest.svg',
          color: Colors.white,
          width: 16,
          height: 16,
        ),
        iconSize: 48,
        onPressed: () {
          onTap();
        },
      ),
    );
  }
}
