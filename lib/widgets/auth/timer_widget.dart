import 'dart:async';

import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final VoidCallback
      onTimerEnd; // Функция, вызываемая при нажатии кнопки после окончания таймера

  const TimerWidget({super.key, required this.onTimerEnd});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _start = 59;
  Timer? _timer;
  bool _showButton = false; // Флаг для отображения кнопки вместо таймера

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Сбрасываем таймер и начальное значение
    setState(() {
      _start = 59; // Устанавливаем начальное значение
      _showButton = false; // Скрываем кнопку и показываем таймер
    });

    _timer?.cancel(); // Отменяем предыдущий таймер, если он есть
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _showButton = true; // Показываем кнопку после завершения таймера
        });
        timer.cancel(); // Останавливаем таймер
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: _showButton
            ? InkWell(
                onTap: () {
                  widget.onTimerEnd(); // Вызываем переданную функцию
                  _startTimer(); // Перезапускаем таймер
                },
                child: Text(
                  "Отправить повторно",
                  style: context.text.bodyText16White.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              )
            : RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: tr('timer.time_left'), // Статичный текст
                      style: context.text.bodyText16White,
                    ),
                    TextSpan(
                      text: tr(
                        'timer.time_left_seconds',
                        namedArgs: {
                          'seconds': _start.toString().padLeft(2, '0')
                        }, // Передаем значение таймера
                      ),
                      style: context.text.bodyText12Grey.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
