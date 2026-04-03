import 'package:flutter/foundation.dart';

class AppOptions {
  static const String baseUrl = 'http://193.180.213.209:8000/api/';

  /// WebSocket URL для чата поддержки (на базе baseUrl: http->ws, https->wss, без /api/).
  static String get supportWebSocketUrl {
    final uri = Uri.parse(baseUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final portSuffix = (uri.port == 80 && uri.scheme == 'http') ||
            (uri.port == 443 && uri.scheme == 'https')
        ? ''
        : ':${uri.port}';
    return '$scheme://${uri.host}$portSuffix/ws/support/';
  }
}
