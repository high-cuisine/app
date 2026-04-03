import 'package:cocktails/theme/text_styles.dart';
import 'package:flutter/material.dart';

extension ThemeTextStylesExtension on BuildContext {
  AppTextStyles get text => Theme.of(this).extension<AppTextStyles>()!;
}
