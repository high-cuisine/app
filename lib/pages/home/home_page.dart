import 'package:cocktails/pages/home/popups/cocktail_selection_pop_up.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/home/info_tile_home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/notification_bloc/notification_bloc.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/account/profile_avatar.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/custom_button.dart';
import '../auth/popups/auth_pop_up.dart';
import '../bonus_page/bonus_screen.dart';
import 'favorite_cocktails_page.dart';
import 'my_cocktail_list_page.dart';
import 'notification_page/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  void _refreshData() {
    context.read<AuthBloc>().add(CheckAuthStatus());
    context.read<ProfileBloc>().add(FetchProfile());
    context.read<NotificationBloc>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              setState(
                  () {}); // Обновляем состояние после получения данных профиля
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  // const CustomSearchBar(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const ProfileAvatar(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 35.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Используем BlocBuilder для проверки состояния авторизации
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, authState) {
                                  if (authState is AuthAuthenticated) {
                                    // Если пользователь авторизован
                                    return BlocBuilder<ProfileBloc,
                                        ProfileState>(
                                      builder: (context, profileState) {
                                        String name =
                                            tr('home.greeting_default');

                                        if (profileState is ProfileLoaded) {
                                          final profile =
                                              profileState.profileData;
                                          final firstName =
                                              profile['first_name'] ??
                                                  tr('home.greeting_default');
                                          name = tr('home.greeting',
                                              namedArgs: {'name': firstName});
                                        }

                                        return Text(
                                          name,
                                          maxLines: 2,
                                          style: context.text.headline24White,
                                        );
                                      },
                                    );
                                  } else {
                                    // Если пользователь не авторизован
                                    return Text(tr('home.greeting_default'),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.text.headline24White);
                                  }
                                },
                              ),
                              const SizedBox(height: 14),
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  if (state is AuthUnauthenticated) {
                                    return CustomRegistrationButton(
                                      text: tr('home.register_button'),
                                      onTap: () {
                                        authPopUp(context);
                                      },
                                      haveIcon: false,
                                    );
                                  } else {
                                    return Container(); // Если авторизован, ничего не показываем
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      if (authState is AuthAuthenticated) {
                        // Показываем карточку с баллами и другой информацией только для авторизованных пользователей
                        return Card(
                          color: Colors.white.withOpacity(0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: Color(0xff343434),
                              width: 1.0,
                            ),
                          ),
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, profileState) {
                              if (profileState is ProfileLoaded) {
                                final profile = profileState.profileData;
                                final points = profile['points'] ?? 0;
                                final recipesCount =
                                    profile['recipes_count'] ?? 0;
                                final favoritesCount =
                                    profile['favorite_recipes_count'] ?? 0;

                                return Column(
                                  children: [
                                    InfoTileHome(
                                      icon: 'assets/images/gift_icon.svg',
                                      title: tr('home.my_points'),
                                      subtitle: tr('home.points', namedArgs: {
                                        'count': points.toString()
                                      }),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const BonusScreen(),
                                        ))
                                            .then((result) {
                                          if (result == true) {
                                            _refreshData(); // Обновляем данные только если вернулись с изменениями
                                          }
                                        });
                                      },
                                    ),
                                    const Divider(
                                        color: Color(0xff343434), height: 1),
                                    InfoTileHome(
                                      icon: 'assets/images/cocktail_icon.svg',
                                      title: tr('home.my_cocktails'),
                                      subtitle: tr('home.recipes', namedArgs: {
                                        'count': recipesCount.toString()
                                      }),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyCocktailsListPage()))
                                            .then((result) {
                                          if (result == true) {
                                            _refreshData(); // Обновляем данные только если вернулись с изменениями
                                          }
                                        });
                                      },
                                    ),
                                    const Divider(
                                        color: Color(0xff343434), height: 1),
                                    InfoTileHome(
                                      icon: 'assets/images/heart_icon.svg',
                                      title: tr('home.favorites'),
                                      subtitle: tr('home.favorite_recipes',
                                          namedArgs: {
                                            'count': favoritesCount.toString()
                                          }), // Использование namedArgs
                                      onTap: () async {
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const FavoriteCocktailsPage(),
                                          ),
                                        )
                                            .then((result) {
                                          if (result == true) {
                                            _refreshData(); // Обновляем данные только если вернулись с изменениями
                                          }
                                        });
                                      },
                                    ),
                                    const Divider(
                                        color: Color(0xff343434), height: 1),
                                    BlocBuilder<NotificationBloc,
                                        NotificationState>(
                                      builder: (context, notificationState) {
                                        if (notificationState
                                            is NotificationLoaded) {
                                          final unreadNotificationsCount =
                                              notificationState.notifications
                                                  .where((notification) =>
                                                      !notification.isRead)
                                                  .length;

                                          return InfoTileHome(
                                            icon: unreadNotificationsCount == 0
                                                ? 'assets/images/mail_icon.svg'
                                                : 'assets/images/mail_active_icon.svg',
                                            title: tr('home.notifications'),
                                            subtitle: unreadNotificationsCount !=
                                                    0
                                                ? tr('home.new_notifications',
                                                    namedArgs: {
                                                        'count':
                                                            unreadNotificationsCount
                                                                .toString()
                                                      })
                                                : '',
                                            onTap: () async {
                                              // Открываем экран уведомлений
                                              final result =
                                                  await Navigator.of(context)
                                                      .push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NotificationPage()),
                                              );

                                              // Если вернулись с обновленными данными, перезагружаем уведомления
                                              if (result == true) {
                                                context
                                                    .read<NotificationBloc>()
                                                    .add(LoadNotifications());
                                              }
                                            },
                                          );
                                        } else {
                                          return InfoTileHome(
                                            icon: 'assets/images/mail_icon.svg',
                                            title: tr('home.notifications'),
                                            subtitle: "",
                                            onTap: () async {
                                              final result =
                                                  await Navigator.of(context)
                                                      .push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NotificationPage()),
                                              );

                                              // Если вернулись с обновленными данными, перезагружаем уведомления
                                              if (result == true) {
                                                context
                                                    .read<NotificationBloc>()
                                                    .add(LoadNotifications());
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              } else if (profileState is ProfileError) {
                                return Text(
                                  tr('errors.server_error'),
                                  style: context.text.bodyText16White,
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        );
                      } else {
                        return Container(
                          height: 125,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 51),
                  CustomButton(
                    text: tr('home.select_cocktail_button'),
                    onPressed: () {
                      final authState = context.read<AuthBloc>().state;
                      // if (authState is AuthAuthenticated) {
                      cocktailSelectionPopUp(context);

                      // } else {
                      //   needRegistrationPopUp(context);
                      // }
                    },
                    single: true,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// gradient: RadialGradient(
//   center: const Alignment(0.6, -1.3), // Центр градиента
//   radius: 1.0, // Радиус градиента
//   colors: [
//     Color(0xFFE76E24).withOpacity(1.0), // Полностью непрозрачный
//     Color(0xFFE76E24).withOpacity(0.45),
//     Color(0xFFE76E24).withOpacity(0.4),
//     Color(0xFFE76E24).withOpacity(0.35),
//     Color(0xFFE76E24).withOpacity(0.3),
//     Color(0xFFE76E24).withOpacity(0.25),
//     Color(0xFFE76E24).withOpacity(0.2),
//     Color(0xFFE76E24).withOpacity(0.15),
//     Color(0xFFE76E24).withOpacity(0.1),
//     Color(0xFFE76E24).withOpacity(0.05),
//   ],)
// Позиции цветов
