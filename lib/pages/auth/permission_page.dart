import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/permission_widget.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage5 extends StatelessWidget {
  final PageController pageController;

  const RegistrationPage5({
    super.key,
    required this.pageController,
  });

  Future<void> _requestPermissions(BuildContext context) async {
    // Запрашиваем доступ к камере
    PermissionStatus cameraStatus = await Permission.camera.request();

    // Запрашиваем разрешение на отправку уведомлений
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final bool notificationsGranted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        false;

    // Независимо от статуса разрешений, проверяем авторизацию и переходим к следующему экрану
    context.read<AuthBloc>().add(CheckAuthStatus());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const CustomBottomNavigationBar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {}
      },
      builder: (context, state) {
        return BasePopup(
          text: tr('registration_page.permissions_title'),
          arrow: false,
          onPressed: () {
            pageController.animateToPage(2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PermissionWidget(
                text: tr('registration_page.camera_permission_text'),
                headLineText:
                    tr('registration_page.camera_permission_headline'),
                svg: 'assets/images/camera_icon.svg',
              ),
              const SizedBox(height: 24),
              PermissionWidget(
                text: tr('registration_page.notifications_permission_text'),
                headLineText:
                    tr('registration_page.notifications_permission_headline'),
                svg: 'assets/images/notifications_icon.svg',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: CustomButton(
                        text: tr('registration_page.decline_button'),
                        grey: true,
                        onPressed: () {
                          context.read<AuthBloc>().add(CheckAuthStatus());
                          if (state is AuthAuthenticated) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CustomBottomNavigationBar(),
                              ),
                            );
                          }
                        },
                        single: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: CustomButton(
                        text: tr('registration_page.confirm_button'),
                        onPressed: () {
                          _requestPermissions(context);
                        },
                        single: false,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
