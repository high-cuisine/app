import 'dart:convert';

import 'package:cocktails/options.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../models/message_model.dart';
import '../../../utilities/language_swich.dart';
import '../../../widgets/account/chat_bubble.dart';
import '../../../widgets/custom_arrowback.dart';

class SupportServicePage extends StatefulWidget {
  final int userId;

  const SupportServicePage({super.key, required this.userId});

  @override
  State<SupportServicePage> createState() => SupportServicePageState();
}

class SupportServicePageState extends State<SupportServicePage> {
  final TextEditingController _messageController = TextEditingController();
  WebSocketChannel? _channel;
  bool _isConnected = false;
  List<Message> _messages = [];

  final ScrollController _scrollController =
      ScrollController(); // Контроллер для списка сообщений

  @override
  void initState() {
    super.initState();
    _connectWebSocket(); // Подключаем WebSocket при инициализации
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose(); // Освобождаем ресурсы контроллера списка
    _disconnectWebSocket(); // Закрываем соединение при удалении виджета
    super.dispose();
  }

  void _connectWebSocket() {
    try {
      final wsUrl =
          '${AppOptions.supportWebSocketUrl}?user_id=${widget.userId}';
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _isConnected = true;
      print("Соединение установлено: $wsUrl");

      _channel!.stream.listen(
        (data) {
          print("Получены данные: $data");
          final decodedData = jsonDecode(data) as Map<String, dynamic>;

          if (decodedData['type'] == 'chat_history') {
            List<Message> messages = (decodedData['history'] as List)
                .map((msg) => Message.fromJson(msg as Map<String, dynamic>))
                .toList();
            setState(() {
              _messages = messages;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          } else if (decodedData['type'] == 'chat_message' ||
              decodedData['type'] == 'new_message') {
            // Бэкенд присылает type: chat_message, message, user_id (timestamp может отсутствовать)
            final timestamp = decodedData['timestamp'] != null
                ? DateTime.parse(decodedData['timestamp'] as String)
                : DateTime.now();
            final newMessage = Message(
              message: decodedData['message'] as String,
              userId: decodedData['user_id'] as int,
              timestamp: timestamp,
            );
            setState(() {
              _messages.add(newMessage);
            });
            _scrollToBottom();
          }
        },
        onError: (e) {
          _isConnected = false;
          print("Ошибка WebSocket: $e");
          if (mounted) setState(() {});
        },
        onDone: () {
          _isConnected = false;
          if (mounted) setState(() {});
        },
        cancelOnError: false,
      );
    } catch (e) {
      _isConnected = false;
      print("Ошибка при подключении: $e");
      if (mounted) setState(() {});
    }
  }

  void _disconnectWebSocket() {
    if (_channel != null) {
      _channel!.sink.close(1000, 'Normal closure');
      _isConnected = false;
      print("Соединение закрыто");
    }
  }

  void _sendMessage() {
    if (!_isConnected || _channel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('support_page.sending_failed'))),
      );
      return;
    }
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final jsonMessage = jsonEncode({
      "message": messageText,
      "user_id": widget.userId,
    });
    _channel!.sink.add(jsonMessage);
    _messageController.clear();
    // Сообщение появится в списке после ответа от сервера (type: chat_message)
    _scrollToBottom();
  }

  // Для reverse: true, чтобы показать последние сообщения снизу, прокручиваем к смещению 0
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Функция, сравнивающая даты сообщений
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Форматирование даты для разделителя (можно использовать intl или свою функцию)
  Future<String> getCurrentLanguage() async {
    String lang = await LanguageService.getLanguage();
    if (lang == 'eng') return 'en'; // Если язык 'eng', используем 'en' для intl
    return 'ru'; // По умолчанию русский
  }

// Функция форматирования даты сообщений с учетом языка
  Future<String> formatMessageDate(DateTime date) async {
    String locale = await getCurrentLanguage();
    final now = DateTime.now();

    if (date.year == now.year) {
      return DateFormat("d MMMM", locale).format(date); // "12 мая" или "May 12"
    } else {
      return DateFormat("d MMMM yyyy", locale)
          .format(date); // "12 мая 2023" или "May 12, 2023"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(
            children: [
              CustomAppBar(
                text: tr('support_page.title'),
                arrow: true,
                auth: false,
                onPressed: null,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Отображаем сообщения снизу вверх
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    // При reverse: true, индекс 0 соответствует последнему (новейшему) сообщению.
                    // Получаем реальный индекс сообщения в исходном списке.
                    final int messageIndex = _messages.length - 1 - index;
                    final message = _messages[messageIndex];
                    final isUserMessage = message.userId == widget.userId;

                    // Определяем, нужно ли показывать разделитель с датой:
                    // Если это самое старое сообщение, или дата текущего сообщения отличается от предыдущего (хронологически более старого)
                    bool showDateDivider = false;
                    if (messageIndex == 0) {
                      showDateDivider = true;
                    } else {
                      final previousMessage = _messages[messageIndex - 1];
                      showDateDivider = !isSameDay(
                          message.timestamp, previousMessage.timestamp);
                    }

                    final String formattedTime =
                        DateFormat.Hm().format(message.timestamp);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDateDivider)
                          FutureBuilder<String>(
                            future: formatMessageDate(message.timestamp),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox
                                    .shrink(); // Ждем загрузки, скрываем элемент
                              }
                              return Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    snapshot.data!,
                                    style: context.text.bodyText16White,
                                  ),
                                ),
                              );
                            },
                          ),
                        ChatBubble(
                          message: message,
                          isUserMessage: isUserMessage,
                          // Если требуется логика "isFirstInSeries" для аватаров, можно добавить её дополнительно,
                          // но для простоты здесь оставляем false
                          isFirstInSeries: false,
                          formattedTime: formattedTime,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: tr('support_page.write_message'),
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                          'assets/images/send_messege_icon.svg'),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }
}
