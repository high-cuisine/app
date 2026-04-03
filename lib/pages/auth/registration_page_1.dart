import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../provider/cocktail_auth_repository.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage1 extends StatefulWidget {
  final PageController pageController;
  final PageController mainPageController;
  final Function(String) onEmailEntered;

  const RegistrationPage1({
    super.key,
    required this.pageController,
    required this.mainPageController,
    required this.onEmailEntered,
  });

  @override
  RegistrationPage1State createState() => RegistrationPage1State();
}

class RegistrationPage1State extends State<RegistrationPage1> {
  final emailController = TextEditingController();
  String? emailError; // Для хранения ошибки email

  // Функция для проверки корректности email с использованием регулярного выражения
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _onSubmit(BuildContext context) {
    setState(() {
      emailError = null; // Сброс ошибок
    });

    final email = emailController.text;

    if (email.isEmpty) {
      setState(() {
        emailError = tr(
            'registration_page.email_error_empty'); // Локализованное сообщение об ошибке пустого email
      });
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        emailError = tr(
            'registration_page.email_error_invalid'); // Локализованное сообщение о некорректном email
      });
      return;
    }

    // Отправляем запрос на верификацию email
    context.read<AuthBloc>().add(VerifyEmailRequested(email));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: BasePopup(
        text: tr('registration_page.title'),
        // Локализованный заголовок "Регистрация"
        onPressed: () {
          widget.mainPageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              labelText: tr('registration_page.email_label'),
              // Локализованное поле "Эл. почта"
              controller: emailController,
              errorMessage: emailError, // Отображение ошибки
            ),
            const SizedBox(height: 24),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoading) {
                  print('AuthLoading state');
                  const Center(child: CircularProgressIndicator());
                } else if (state is EmailVerified) {
                  print('EmailVerified state');
                  widget
                      .onEmailEntered(emailController.text); // Сохранение email
                  widget.pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                } else if (state is AuthError) {
                  if (state.message.contains('400')) {
                    setState(() {
                      emailError = tr(
                          'registration_page.email_error_registered'); // Локализованное сообщение, если email уже зарегистрирован
                    });
                  }
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: tr('registration_page.next_button'),
                  // Локализованная кнопка "Далее"
                  onPressed: () {
                    _onSubmit(context); // Валидация и отправка
                  },
                  single: true,
                );
              },
            ),
            const SizedBox(height: 24.0),
            TextWithLines(text: tr('registration_page.alternative_sign_in')),
            // Локализованный текст "или с помощью"
            const SizedBox(height: 24),
            // RegistrationServicesButton(
            //   text: tr('registration_page.apple_id_button'),
            //   // Локализованная кнопка "Apple ID"
            //   onPressed: () {},
            // ),
            const SizedBox(height: 12),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthGoogleLoading) {
                  print('AuthGoogleLoading state');
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                } else if (state is AuthAuthenticated) {
                  print('AuthAuthenticated state');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const CustomBottomNavigationBar()),
                  );
                } else if (state is AuthGoogleError) {
                  print('AuthGoogleError state');
                  print('google error');
                  Navigator.of(context).pop(); // Закрываем окно загрузки
                  setState(() {});
                } else if (state is AuthUnauthenticated) {}
              },
              builder: (context, state) {
                return RegistrationServicesButton(
                  text: tr('sign_in_page.google_button'),
                  onPressed: () {
                    context.read<AuthBloc>().add(SignInWithGoogleRequested());
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            // RegistrationServicesButton(
            //   text: tr('registration_page.facebook_button'),
            //   // Локализованная кнопка "Facebook"
            //   onPressed: () {},
            // ),
            const SizedBox(height: 24.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: tr('registration_page.already_have_account'),
                    // Локализованный текст "Уже есть аккаунт?"
                    style: context.text.bodyText12Grey.copyWith(fontSize: 16),
                  ),
                  TextSpan(
                    text: tr('registration_page.login_link'),
                    // Локализованная ссылка "Войти"
                    style: context.text.bodyText16White,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        widget.mainPageController.animateToPage(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
