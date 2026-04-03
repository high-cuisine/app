import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/notification_bloc/notification_bloc.dart';
import '../../../provider/notification_repository.dart';
import '../../../widgets/custom_arrowback.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(NotificationRepository())
        ..add(LoadNotifications())
        ..add(MarkNotificationsAsRead()),
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 40),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                CustomAppBar(
                  auth: true,
                  text: tr("notifications_page.title"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Expanded(
                  child: BlocBuilder<NotificationBloc, NotificationState>(
                    builder: (context, state) {
                      if (state is NotificationLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is NotificationError) {
                        return Center(
                          child: Text(
                            tr("errors.server_error"),
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is NotificationLoaded) {
                        final notifications = state.notifications;
                        if (notifications.isEmpty) {
                          return Center(
                              child: Text(
                            tr("notifications_page.no_notification"),
                            style: context.text.bodyText16White,
                          ));
                        }

                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              // Отступы между уведомлениями
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                // Белый цвет с прозрачностью 2%
                                borderRadius: BorderRadius.circular(10),
                                // Округление в 10
                                border: Border.all(
                                  color:
                                      const Color(0xff343434), // Цвет границы
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                // Внутренний отступ контейнера
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notification.topik,
                                            style: notification.isRead
                                                ? context.text.bodyText12Grey
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: Colors.grey
                                                            .withOpacity(0.6))
                                                : context.text.bodyText16White,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            notification.message,
                                            style: notification.isRead
                                                ? context.text.bodyText12Grey
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: Colors.grey
                                                            .withOpacity(0.3))
                                                : context.text.bodyText12Grey
                                                    .copyWith(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink(); // Заглушка
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
