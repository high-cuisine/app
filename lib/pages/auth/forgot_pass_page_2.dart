import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/timer_widget.dart';
import '../../widgets/custom_button.dart';

class ForgotPassPage2 extends StatefulWidget {
  final PageController pageController;
  final String email;
  final Function(String) onCodeEntered;

  const ForgotPassPage2({
    super.key,
    required this.pageController,
    required this.email,
    required this.onCodeEntered,
  });

  @override
  State<ForgotPassPage2> createState() => _ForgotPassPage2State();
}

class _ForgotPassPage2State extends State<ForgotPassPage2> {
  late String email;

  @override
  void initState() {
    super.initState();
    email = widget.email; // Присвоение начального значения
  }

  void _resendCode() {
    context.read<AuthBloc>().add(RequestPasswordReset(email: email));
    print('Код повторно отправлен на ${email}');
  }

  final codeController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              const Center(child: CircularProgressIndicator());
            } else if (state is PasswordResetCodeConfirmed) {
              widget.onCodeEntered(codeController.text);
              widget.pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            } else if (state is AuthError) {
              setState(() {
                errorMessage = tr(
                    'forgot_password_page.invalid_code_error'); // Локализованная ошибка "Неверный код"
              });
            }
          },
          builder: (context, state) {
            return BasePopup(
              text: tr('forgot_password_page.code_title'),
              // Локализованная строка "Код подтверждения"
              onPressed: () {
                widget.pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CenterText(
                    text: tr('forgot_password_page.code_sent_description',
                        namedArgs: {'email': email}),
                    // Локализованная строка "Мы отправили код на почту {email}"
                    padding: 60,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: tr('forgot_password_page.code_label'),
                    // Локализованная строка "Код"
                    controller: codeController,
                    errorMessage: errorMessage, // Ошибка кода
                  ),
                  const SizedBox(height: 24.0),
                  TimerWidget(
                    onTimerEnd: _resendCode,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: tr('forgot_password_page.submit_code'),
                    // Локализованная строка "Подтвердить"
                    onPressed: () {
                      final code = codeController.text.trim();

                      if (code.isEmpty) {
                        setState(() {
                          errorMessage = tr(
                              'forgot_password_page.enter_code_error'); // Локализованная ошибка "Введите код подтверждения"
                        });
                      } else {
                        setState(() {
                          errorMessage = null;
                        });

                        context.read<AuthBloc>().add(
                              ConfirmResetCode(email: email, code: code),
                            );
                      }
                    },
                    single: true,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
