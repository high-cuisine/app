import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/timer_widget.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage2 extends StatefulWidget {
  final PageController pageController;
  final String email;

  const RegistrationPage2({
    super.key,
    required this.pageController,
    required this.email,
  });

  @override
  State<RegistrationPage2> createState() => _RegistrationPage2State();
}

class _RegistrationPage2State extends State<RegistrationPage2> {
  final codeController = TextEditingController();
  String? codeError; // Переменная для отображения ошибки

  void _onSubmit(BuildContext context) {
    setState(() {
      codeError = null; // Сбрасываем ошибку перед проверкой
    });

    final code = codeController.text;

    if (code.isEmpty) {
      setState(() {
        codeError = tr(
            'registration_page.enter_code_error'); // Локализованное сообщение об ошибке пустого поля кода
      });
      return;
    }

    // Если код введен, отправляем запрос на проверку
    context.read<AuthBloc>().add(
          ConfirmCodeRequested(widget.email, code),
        );
  }

  void _resendCode() {
    // Метод для повторной отправки кода
    context.read<AuthBloc>().add(RequestPasswordReset(email: widget.email));
    print('Повторно отправлен код на ${widget.email}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print("Current state: $state");
        if (state is AuthLoading) {
          print('AuthLoading 2 state');
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is CodeConfirmed) {
          Navigator.pop(context); // Закрываем диалог загрузки
          widget.pageController.animateToPage(2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        } else if (state is PasswordResetRequested) {
          Navigator.pop(
              context); // Закрываем диалог, если состояние изначальное
        } else if (state is AuthError) {
          Navigator.pop(context); // Закрываем диалог загрузки
          setState(() {
            codeError = tr(
                'registration_page.invalid_code_error'); // Локализованное сообщение об ошибке неверного кода
          });
        }
      },
      builder: (context, state) {
        return BasePopup(
          text: tr('registration_page.confirmation_code_title'),
          // Локализованный заголовок "Код подтверждения"
          onPressed: () {
            widget.pageController.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CenterText(
                text: tr('registration_page.code_sent_description',
                    namedArgs: {'email': widget.email}),
                // Локализованное сообщение о том, что код отправлен на email
                padding: 60,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                labelText: tr('registration_page.code_label'),
                // Локализованное поле "Код"
                controller: codeController,
                errorMessage: codeError, // Отображение ошибки
              ),
              const SizedBox(height: 24.0),
              TimerWidget(
                onTimerEnd: _resendCode,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: tr('registration_page.submit_button'),
                // Локализованная кнопка "Подтвердить"
                onPressed: () {
                  _onSubmit(context); // Проверка и отправка
                },
                single: true,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
