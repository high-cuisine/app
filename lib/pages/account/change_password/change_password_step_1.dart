import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';
import 'change_password_step_2.dart';

class ChangePasswordStep1 extends StatefulWidget {
  const ChangePasswordStep1({super.key});

  @override
  State<ChangePasswordStep1> createState() => ChangePasswordStep1State();
}

class ChangePasswordStep1State extends State<ChangePasswordStep1> {
  final emailController = TextEditingController();
  String? emailError; // Для хранения ошибки email

  void _onSubmit() {
    setState(() {
      emailError = null; // Сброс ошибки перед отправкой
    });

    final email = emailController.text;

    // Валидация email
    if (email.isEmpty) {
      setState(() {
        emailError =
            tr("change_pass_pages.enter_your_email"); // Если email не введен
      });
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        emailError = tr(
            "change_pass_pages.enter_correct_email"); // Проверка формата email
      });
    } else {
      // Отправка запроса на сброс пароля, если валидация прошла
      context.read<AuthBloc>().add(RequestPasswordReset(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          const Center(child: CircularProgressIndicator());
        } else if (state is PasswordResetRequested) {
          Navigator.pop(context); // Закрываем диалог загрузки
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ChangePasswordStep2(email: emailController.text),
          ));
        } else if (state is AuthError) {
          Navigator.pop(context); // Закрываем диалог загрузки
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
              child: Column(
                children: [
                  CustomAppBar(
                    text: tr("change_pass_pages.change_pass"),
                    arrow: true,
                    auth: false,
                    onPressed: null,
                  ),
                  const SizedBox(height: 33),
                  CenterText(
                    text: tr("change_pass_pages.enter_email_for_code"),
                    padding: 60,
                    pop: false,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: tr("change_pass_pages.email"),
                    controller: emailController,
                    errorMessage: emailError, // Показ ошибки под полем
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: tr("buttons.send"),
                    onPressed: _onSubmit, // Валидация и отправка
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
