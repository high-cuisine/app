import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0E0E0E),
            Color(0xFFEEB419),
            Color(0xFFE0282E),
          ],
          stops: [0.1, 0.5, 1],
        ),
      ),
      child: child,
    );
  }
}
