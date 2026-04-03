import 'package:cocktails/widgets/account/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/avatar_cubit/avatar_cubit.dart';
import '../../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isUserMessage;
  final bool isFirstInSeries;
  final String formattedTime; // Добавляем время

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUserMessage,
    required this.isFirstInSeries,
    required this.formattedTime, // Принимаем отформатированное время
  });

  @override
  Widget build(BuildContext context) {
    // Ограничиваем максимальную ширину бабла сообщений до 80% ширины экрана
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.80;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUserMessage && isFirstInSeries) ...[
            // Аватар поддержки отображается только для первого сообщения в серии
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/support_avatar.png'),
              radius: 20,
            ),
            const SizedBox(width: 10),
          ] else
            const SizedBox(width: 50),
          // Отступ для выравнивания

          // Используем Flexible и ConstrainedBox для контроля максимальной ширины сообщения
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                decoration: BoxDecoration(
                  color: isUserMessage
                      ? const Color(0xffF6B402)
                      : Colors.white.withOpacity(0.06),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // Для выравнивания времени
                  children: [
                    Text(
                      message.message,
                      style: isUserMessage
                          ? const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF643904),
                            )
                          : const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                    ),
                    const SizedBox(height: 5),
                    // Отображаем время отправки сообщения
                    Text(
                      formattedTime,
                      style: isUserMessage
                          ? const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF643904),
                            )
                          : const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isUserMessage && isFirstInSeries) ...[
            const SizedBox(width: 10),
            // Аватар пользователя отображается только для первого сообщения в серии
            BlocBuilder<ProfileImageCubit, String?>(
                builder: (context, imagePath) {
              return const ProfileAvatar(
                radius: 20,
              );
            }),
          ] else
            const SizedBox(width: 50),
          // Отступ для выравнивания
        ],
      ),
    );
  }
}
