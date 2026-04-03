import 'package:flutter/cupertino.dart';

import 'custom_arrowback.dart';

class BasePopup extends StatelessWidget {
  final Widget child;
  final bool arrow;
  final String text;
  final dynamic onPressed;

  const BasePopup({
    super.key,
    required this.child,
    this.arrow = true,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E0E0E), Color(0xFF251511)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.86,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      width: 42.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF343434),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomAppBar(
                    auth: true,
                    text: text,
                    arrow: arrow,
                    onPressed: () {
                      if (onPressed != null) {
                        onPressed();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
