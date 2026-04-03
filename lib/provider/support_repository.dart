import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/message_model.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  final StreamController<List<Message>> _messageController =
      StreamController<List<Message>>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  Stream<List<Message>> get messageStream => _messageController.stream;

  void connect(int userId) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://37.252.17.123:8000//ws/support/?user_id=$userId'),
      );
      _isConnected = true;
      _connectionStatusController.add(true);
      print("Соединение установлено");

      // Подписываемся на поток сообщений
      _channel!.stream.listen((data) {
        print("Данные из WebSocket: $data");
        final decodedData = jsonDecode(data);

        if (decodedData['type'] == 'chat_history') {
          List<Message> messages = (decodedData['history'] as List)
              .map((msg) => Message.fromJson(msg))
              .toList();
          _messageController.add(messages);
        }
      });
    } catch (e) {
      _isConnected = false;
      _connectionStatusController.add(false);
      print("Ошибка при подключении WebSocket: $e");
    }
  }

  void sendMessage(String message) {
    if (!_isConnected || _channel == null) {
      print("Сообщение не может быть отправлено: нет соединения");
      return;
    }
    _channel!.sink.add(jsonEncode({"message": message}));
    print("Сообщение отправлено: $message");
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close(1000, 'Normal closure');
      _isConnected = false;
      _connectionStatusController.add(false);
      print("Соединение закрыто");
    }
  }
}
