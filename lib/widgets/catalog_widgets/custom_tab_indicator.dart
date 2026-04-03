import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, onChanged);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = Color(0xFFF6B402) // Цвет индикатора
      ..style = PaintingStyle.fill;

    final double width = configuration.size!.width;
    final double height = 5.0; // Высота линии

    final Rect rect = Rect.fromLTWH(
      offset.dx + (width * 0.0), // Смещение для центрирования
      offset.dy + configuration.size!.height - height,
      width * 1, // Длина индикатора
      height,
    );

    final RRect roundedRect =
        RRect.fromRectAndRadius(rect, const Radius.circular(50));
    canvas.drawRRect(roundedRect, paint);
  }
}
