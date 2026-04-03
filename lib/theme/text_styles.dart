import 'package:flutter/material.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle headline24White;
  final TextStyle headline20White;
  final TextStyle buttonText18Brown;
  final TextStyle bodyText16White;
  final TextStyle bodyText14White;
  final TextStyle bodyText12Grey;
  final TextStyle bodyText11Grey;

  const AppTextStyles({
    required this.headline24White,
    required this.headline20White,
    required this.buttonText18Brown,
    required this.bodyText16White,
    required this.bodyText14White,
    required this.bodyText12Grey,
    required this.bodyText11Grey,
  });

  @override
  AppTextStyles copyWith({
    TextStyle? headline24White,
    TextStyle? headline20White,
    TextStyle? buttonText18Brown,
    TextStyle? bodyText16White,
    TextStyle? bodyText14White,
    TextStyle? bodyText12Grey,
    TextStyle? bodyText11Grey,
  }) {
    return AppTextStyles(
      headline24White: headline24White ?? this.headline24White,
      headline20White: headline20White ?? this.headline20White,
      buttonText18Brown: buttonText18Brown ?? this.buttonText18Brown,
      bodyText16White: bodyText16White ?? this.bodyText16White,
      bodyText14White: bodyText14White ?? this.bodyText14White,
      bodyText12Grey: bodyText12Grey ?? this.bodyText12Grey,
      bodyText11Grey: bodyText11Grey ?? this.bodyText11Grey,
    );
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) {
      return this;
    }

    return AppTextStyles(
      headline24White:
          TextStyle.lerp(headline24White, other.headline24White, t)!,
      headline20White:
          TextStyle.lerp(headline20White, other.headline20White, t)!,
      buttonText18Brown:
          TextStyle.lerp(buttonText18Brown, other.buttonText18Brown, t)!,
      bodyText16White:
          TextStyle.lerp(bodyText16White, other.bodyText16White, t)!,
      bodyText14White:
          TextStyle.lerp(bodyText14White, other.bodyText14White, t)!,
      bodyText12Grey: TextStyle.lerp(bodyText12Grey, other.bodyText12Grey, t)!,
      bodyText11Grey: TextStyle.lerp(bodyText11Grey, other.bodyText11Grey, t)!,
    );
  }

  static get light => const AppTextStyles(
        headline24White: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headline20White: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        buttonText18Brown: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF643904),
        ),
        bodyText16White: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyText14White: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyText12Grey: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFB7B7B7),
        ),
        bodyText11Grey: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFFB7B7B7),
        ),
      );

  static get dark => const AppTextStyles(
        headline24White: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headline20White: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        buttonText18Brown: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Color(0xFF643904),
        ),
        bodyText16White: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyText14White: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyText12Grey: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Color(0xFFB7B7B7),
        ),
        bodyText11Grey: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFFB7B7B7),
        ),
      );
}
