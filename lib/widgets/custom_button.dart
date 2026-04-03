import 'dart:ui';

import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool transper;
  final bool gradient;
  final bool single;
  final bool grey;
  final VoidCallback onPressed;
  final double buttonHeight;
  final bool haveIcon;

  const CustomButton({
    required this.text,
    this.gradient = false,
    this.transper = false,
    this.grey = false,
    required this.single,
    required this.onPressed,
    super.key,
    this.buttonHeight = 60,
    this.haveIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      backgroundColor: _getBackgroundColor(),
      shadowColor: Colors.transparent,
    );

    final buttonContent = haveIcon
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/copy_bold.svg"),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.buttonText18Brown.copyWith(fontSize: 16),
                ),
              ),
            ],
          )
        : Text(
            text,
            style: context.text.buttonText18Brown.copyWith(
              color: _getTextColor(),
              fontSize: buttonHeight == 60 ? 18 : 16,
            ),
          );

    final button = ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: buttonContent,
    );

    return single
        ? Row(
            children: [
              Expanded(
                  child: SizedBox(
                      height: buttonHeight,
                      child: _wrapWithDecoration(button))),
            ],
          )
        : SizedBox(height: buttonHeight, child: _wrapWithDecoration(button));
  }

  /// Возвращает цвет фона кнопки в зависимости от параметров.
  Color? _getBackgroundColor() {
    if (gradient || transper) return Colors.transparent;
    if (grey) return const Color(0x0FFFFFFF);
    return const Color(0xFFF6B402);
  }

  /// Возвращает цвет текста кнопки в зависимости от параметров.
  Color _getTextColor() {
    if (grey) return const Color(0x66FFFFFF);
    if (transper) return Colors.white;
    return Colors.brown;
  }

  /// Добавляет декорацию кнопке, если она требуется.
  Widget _wrapWithDecoration(Widget child) {
    if (gradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF8C82C), Color(0xFFEF7F31), Color(0xFFDD66A9)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: child,
      );
    } else if (transper) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: child,
        ),
      );
    }
    return child;
  }
}
