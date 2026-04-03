import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class ForgotPassPage3 extends StatefulWidget {
  final PageController pageController;
  final String email;
  final String code;

  const ForgotPassPage3({
    super.key,
    required this.pageController,
    required this.email,
    required this.code,
  });

  @override
  State<ForgotPassPage3> createState() => _ForgotPassPage3State();
}

class _ForgotPassPage3State extends State<ForgotPassPage3> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? passwordError;
  String? confirmPasswordError;
  String? generalError;

  bool hasNavigated = false;

  void _onSubmit(BuildContext context) {
    setState(() {
      passwordError = null;
      confirmPasswordError = null;
      generalError = null;
    });

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    bool isValid = true;
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

    if (password.isEmpty || !passwordRegex.hasMatch(password)) {
      setState(() {
        passwordError = tr(
            'forgot_password_page.password_error'); // Локализованная ошибка для короткого пароля
      });
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = tr(
            'forgot_password_page.confirm_password_error'); // Локализованная ошибка для пустого поля подтверждения
      });
      isValid = false;
    }

    if (password != confirmPassword) {
      setState(() {
        generalError = tr(
            'forgot_password_page.password_mismatch_error'); // Локализованная ошибка для несовпадающих паролей
        isValid = false;
      });
    }

    if (isValid) {
      context.read<AuthBloc>().add(
            ResetPassword(
              code: widget.code,
              email: widget.email,
              newPassword: password,
              repeatPassword: confirmPassword,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // Показываем индикатор загрузки
        } else if (state is AuthAuthenticated && !hasNavigated) {
          setState(() {
            hasNavigated = true; // Помечаем, что навигация выполнена
          });
          // Навигация при успешной авторизации
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CustomBottomNavigationBar(),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return BasePopup(
          text: tr('forgot_password_page.create_password_title'),
          // Локализованный заголовок "Новый пароль"
          onPressed: () {
            widget.pageController.animateToPage(2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CenterText(
                text: tr('forgot_password_page.create_password_description'),
                // Локализованное описание
                padding: 60,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                labelText: tr('forgot_password_page.new_password_label'),
                // Локализованное поле "Новый пароль"
                obscureText: true,
                isJoined: true,
                joinPosition: JoinPosition.top,
                controller: passwordController,
                errorMessage: passwordError,
                showRedBorder: generalError != null,
              ),
              CustomTextField(
                labelText:
                    tr('forgot_password_page.confirm_new_password_label'),
                // Локализованное поле "Повторите новый пароль"
                obscureText: true,
                isJoined: true,
                joinPosition: JoinPosition.bottom,
                controller: confirmPasswordController,
                errorMessage: confirmPasswordError,
                showRedBorder: generalError != null,
              ),
              if (generalError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    generalError!,
                    style:
                        context.text.bodyText12Grey.copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              CustomButton(
                text: tr('forgot_password_page.login_button'),
                // Локализованная кнопка "Войти"
                onPressed: () => _onSubmit(context),
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
