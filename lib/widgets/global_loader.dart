import 'package:flutter/material.dart';

class GlobalLoader {
  static final GlobalLoader _instance = GlobalLoader._internal();

  factory GlobalLoader() => _instance;

  GlobalLoader._internal();

  OverlayEntry? _overlayEntry;

  void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.orange,
          child: LinearProgressIndicator(
            backgroundColor: Colors.black.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
          ),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
