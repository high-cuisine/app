import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../../widgets/auth/center_text.dart';
import '../../../widgets/auth/custom_auth_textfield.dart';
import '../../../widgets/custom_arrowback.dart';
import '../../../widgets/custom_button.dart';

class ChangePasswordStep3 extends StatefulWidget {
  final String email;
  final String code;

  const ChangePasswordStep3({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ChangePasswordStep3> createState() => ChangePasswordStep3State();
}

class ChangePasswordStep3State extends State<ChangePasswordStep3> {
  final newPasswordController = TextEditingController();
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

    final password = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    bool isValid = true;

    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

    if (password.isEmpty || !passwordRegex.hasMatch(password)) {
      setState(() {
        passwordError =
            tr('change_pass_pages.password_too_short'); // Локализация
      });
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError =
            tr('change_pass_pages.repeat_new_password'); // Локализация
      });
      isValid = false;
    }

    if (password != confirmPassword) {
      setState(() {
        generalError = tr('change_pass_pages.password_mismatch'); // Локализация
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
        if (state is PasswordResetSuccess && !hasNavigated) {
          setState(() {
            hasNavigated = true;
          });

          context.read<AuthBloc>().add(CheckAuthStatus());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    tr('change_pass_pages.password_saved'))), // Локализация
          );
          int count = 0;
          Navigator.of(context).popUntil((route) {
            return count++ == 2;
          });
        } else if (state is AuthError) {
          setState(() {
            generalError = state.message;
          });
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
                    text: tr('change_pass_pages.new_password'), // Локализация
                    arrow: true,
                    auth: false,
                    onPressed: null,
                  ),
                  const SizedBox(height: 33),
                  CenterText(
                    text: tr('change_pass_pages.create_password'),
                    // Локализация
                    padding: 60,
                    pop: false,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: tr('change_pass_pages.new_password'),
                    // Локализация
                    obscureText: true,
                    isJoined: true,
                    joinPosition: JoinPosition.top,
                    controller: newPasswordController,
                    errorMessage: passwordError,
                    showRedBorder: generalError != null,
                  ),
                  CustomTextField(
                    labelText: tr('change_pass_pages.repeat_new_password'),
                    // Локализация
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
                        style: context.text.bodyText12Grey
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: tr('buttons.save_changes'), // Локализация
                    onPressed: () => _onSubmit(context),
                    single: true,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
