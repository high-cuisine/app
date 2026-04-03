import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';

class CenterText extends StatelessWidget {
  final String text;
  final double padding;
  final bool pop;

  const CenterText({
    required this.text,
    required this.padding,
    this.pop = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Center(
        child: Text(
          text,
          style: pop
              ? context.text.bodyText12Grey.copyWith(fontSize: 14)
              : context.text.bodyText12Grey.copyWith(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
