import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/auth/timer_widget.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';
import 'change_password_step_3.dart';

class ChangePasswordStep2 extends StatefulWidget {
  final String email;

  const ChangePasswordStep2({super.key, required this.email});

  @override
  State<ChangePasswordStep2> createState() => ChangePasswordStep2State();
}

class ChangePasswordStep2State extends State<ChangePasswordStep2> {
  final codeController = TextEditingController();
  String? codeError; // Переменная для ошибки кода

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() {
      codeError = null; // Сброс ошибки
    });

    final code = codeController.text;

    if (code.isEmpty) {
      setState(() {
        codeError =
            tr("change_pass_pages.enter_code"); // Локализованный текст ошибки
      });
    } else {
      // Отправка кода на сервер для подтверждения
      context.read<AuthBloc>().add(
            ConfirmResetCode(
              email: widget.email,
              code: code,
            ),
          );
    }
  }

  void _resendCode() {
    // Отправляем событие запроса на отправку кода повторно
    context.read<AuthBloc>().add(RequestPasswordReset(email: widget.email));
    print('Код отправлен повторно на ${widget.email}');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetCodeConfirmed) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangePasswordStep3(
              email: widget.email,
              code: codeController.text,
            ),
          ));
        } else if (state is AuthError) {
          setState(() {
            codeError =
                tr("change_pass_pages.wrong_code"); // Локализованная ошибка
          });
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
              child: Column(
                children: [
                  CustomAppBar(
                    text: tr("change_pass_pages.confirmation_code"),
                    // Локализация текста "Смена пароля"
                    arrow: true,
                    auth: false,
                    onPressed: null,
                  ),
                  const SizedBox(height: 33),
                  CenterText(
                    text: tr('change_pass_pages.code_sent',
                        namedArgs: {'email': widget.email}),
                    padding: 60,
                    pop: false,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: tr("change_pass_pages.confirmation_code"),
                    // Локализация для поля "Код"
                    controller: codeController,
                    errorMessage: codeError, // Отображаем ошибку для кода
                  ),
                  const SizedBox(height: 32),
                  TimerWidget(
                    onTimerEnd: _resendCode,
                  ),
                  const SizedBox(height: 29),
                  CustomButton(
                    text: tr('buttons.confirm'),
                    // Локализация кнопки "Подтвердить"
                    onPressed: _onSubmit,
                    // Обработчик нажатия с проверкой кода
                    single: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
