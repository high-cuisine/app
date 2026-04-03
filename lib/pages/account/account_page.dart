import 'package:cocktails/pages/account/support_service/support_service_page.dart';
import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../provider/profile_repository.dart';
import '../../widgets/account/info_tile_account.dart';
import '../../widgets/account/profile_avatar.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/custom_arrowback.dart';
import '../auth/popups/auth_pop_up.dart';
import 'about_app_page.dart';
import 'change_password/change_password_step_1.dart';
import 'editing_account_page.dart';
import 'invite_friends_page.dart';
import 'language.dart';
import 'notification_settings_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  /// Открыть экран поддержки после загрузки профиля (если нажали до загрузки).
  bool _pendingSupportOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatus());
    // На мобильном профиль может ещё не быть загружен — запрашиваем при открытии вкладки
    context.read<ProfileBloc>().add(FetchProfile());
  }

  void _openSupportPage(int userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SupportServicePage(userId: userId),
      ),
    );
  }

  int? _userIdFromProfile(Map<String, dynamic> profileData) {
    for (final key in ['id', 'pk', 'user_id']) {
      final id = profileData[key];
      if (id == null) continue;
      if (id is int) return id > 0 ? id : null;
      final parsed = int.tryParse(id.toString());
      if (parsed != null && parsed > 0) return parsed;
    }
    return null;
  }

  Future<void> _onSupportTap() async {
    if (context.read<AuthBloc>().state is! AuthAuthenticated) return;

    int? userId;
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoaded) {
      userId = _userIdFromProfile(profileState.profileData);
    }
    if (userId == null) {
      final cached = await ProfileRepository().getProfileFromCache();
      if (cached != null) userId = _userIdFromProfile(cached);
    }
    if (userId != null) {
      if (!mounted) return;
      _openSupportPage(userId);
      return;
    }
    setState(() => _pendingSupportOpen = true);
    context.read<ProfileBloc>().add(FetchProfile());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('account_page.loading_profile'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (!_pendingSupportOpen) return;
        if (state is ProfileLoaded) {
          final id = state.profileData['id'];
          final userId = id is int ? id : int.tryParse(id?.toString() ?? '');
          if (userId != null && userId > 0) {
            setState(() => _pendingSupportOpen = false);
            _openSupportPage(userId);
          }
        } else if (state is ProfileError) {
          setState(() => _pendingSupportOpen = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14),
          child: Column(
            children: [
              CustomAppBar(
                text: tr('account_page.title'),
                // Локализованный заголовок "Аккаунт"
                arrow: false,
                auth: false,
                onPressed: null,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  const ProfileAvatar(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 35.0),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          if (authState is AuthAuthenticated) {
                            // Если пользователь авторизован, показываем имя и кнопку "Редактировать"
                            return BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                String fullName = 'Нет данных';

                                if (state is ProfileLoaded) {
                                  final profile = state.profileData;
                                  final firstName =
                                      profile['first_name'] ?? 'Нет данных';
                                  final lastName = profile['last_name'] ?? '';

                                  fullName = lastName.isNotEmpty
                                      ? '$firstName $lastName'
                                      : firstName;
                                }

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(fullName,
                                        maxLines: 2,
                                        style: context.text.headline24White),
                                    const SizedBox(height: 14),
                                    CustomRegistrationButton(
                                      text: tr('account_page.edit'),
                                      // Локализованная строка "Редактировать"
                                      icon: 'assets/images/pen_icon.svg',
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditingAccountPage(),
                                          ),
                                        );
                                      },
                                      haveIcon: true,
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Если пользователь не авторизован, показываем кнопку "Зарегистрироваться"
                            return CustomRegistrationButton(
                              text: tr('account_page.register'),
                              // Локализованная строка "Зарегистрироваться"
                              onTap: () {
                                authPopUp(context);
                              },
                              haveIcon: false,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthAuthenticated) {
                    return Card(
                      color: Colors.white.withOpacity(0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(0xff343434),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          InfoTileAccount(
                            icon: 'assets/images/language_icon.svg',
                            title: tr('account_page.language'),
                            // Локализованная строка "Язык"
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const LanguageSelectionPage()));
                            },
                          ),
                          const Divider(color: Color(0xff343434), height: 1),
                          InfoTileAccount(
                            icon: 'assets/images/pass_change_icon.svg',
                            title: tr('account_page.password'),
                            // Локализованная строка "Пароль"
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePasswordStep1()));
                            },
                          ),
                          const Divider(color: Color(0xff343434), height: 1),
                          InfoTileAccount(
                            icon: 'assets/images/ion_mail-notification.svg',
                            title: tr('account_page.notifications'),
                            // Локализованная строка "Уведомления"
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationSetupPage()));
                            },
                          ),
                          const Divider(color: Color(0xff343434), height: 1),
                          InfoTileAccount(
                            icon: 'assets/images/ion_mail-notification.svg',
                            title: tr('account_page.invite_friends'),
                            // Локализованная строка "Уведомления"
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const InviteFriendsPage()));
                            },
                          ),
                          const Divider(color: Color(0xff343434), height: 1),
                          InfoTileAccount(
                            icon: 'assets/images/contact-support_icon.svg',
                            title: tr('account_page.support'),
                            // Связаться с поддержкой
                            onTap: () => _onSupportTap(),
                          ),
                          const Divider(color: Color(0xff343434), height: 1),
                          InfoTileAccount(
                            icon: 'assets/images/about_app_icon.svg',
                            title: tr('account_page.about_app'),
                            // Локализованная строка "О приложении"
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AboutAppPage()));
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Если пользователь не авторизован, показываем ограниченное меню
                    return Card(
                      color: Colors.white.withOpacity(0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color(0xff343434),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          InfoTileAccount(
                            icon: 'assets/images/language_icon.svg',
                            title: tr('account_page.language'),
                            // Локализованная строка "Язык"
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const LanguageSelectionPage()));
                            },
                          ),
                          const Divider(color: Color(0xff343434), height: 1),
                          InfoTileAccount(
                            icon: 'assets/images/about_app_icon.svg',
                            title: tr('account_page.about_app'),
                            // Локализованная строка "О приложении"
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AboutAppPage()));
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
