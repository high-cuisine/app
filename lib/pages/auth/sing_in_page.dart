import 'package:cocktails/theme/theme_extensions.dart';
import 'package:cocktails/widgets/base_pop_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../provider/cocktail_auth_repository.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/auth/custom_registration_button.dart';
import '../../widgets/auth/text_with_line.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/custom_button.dart';

class SignInPage extends StatefulWidget {
  final PageController pageController;

  const SignInPage({
    super.key,
    required this.pageController,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Переменные для хранения ошибок
  String? usernameError;
  String? passwordError;
  String? generalError;

  void _onSubmit(BuildContext context) {
    // Сброс ошибок перед валидацией
    setState(() {
      usernameError = null;
      passwordError = null;
      generalError = null;
    });

    bool usernameIsEmpty = usernameController.text.isEmpty;
    bool passwordIsEmpty = passwordController.text.isEmpty;

    // Если оба поля пусты, показываем только generalError
    if (usernameIsEmpty && passwordIsEmpty) {
      setState(() {
        generalError = tr('sign_in_page.general_error');
      });
    } else {
      // Если одно из полей пусто, показываем соответствующую ошибку для поля
      if (usernameIsEmpty) {
        setState(() {
          usernameError = tr('sign_in_page.email_error');
        });
      }
      if (passwordIsEmpty) {
        setState(() {
          passwordError = tr('sign_in_page.password_error');
        });
      }
    }

    // Если оба поля заполнены и нет общей ошибки, отправляем запрос
    if (!usernameIsEmpty && !passwordIsEmpty && generalError == null) {
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(
          usernameController.text,
          passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: BasePopup(
        text: tr('sign_in_page.title'),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Builder(
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: usernameController,
                        labelText: tr('sign_in_page.email_label'),
                        isJoined: true,
                        joinPosition: JoinPosition.top,
                        errorMessage:
                            generalError != null ? ' ' : usernameError,
                        // Подсвечиваем поле при общей ошибке
                        showRedBorder: generalError !=
                            null, // Принудительно подсвечиваем границу поля
                      ),
                      CustomTextField(
                        controller: passwordController,
                        labelText: tr('sign_in_page.password_label'),
                        obscureText: true,
                        isJoined: true,
                        joinPosition: JoinPosition.bottom,
                        errorMessage:
                            generalError != null ? ' ' : passwordError,
                        // Подсвечиваем поле при общей ошибке
                        showRedBorder: generalError !=
                            null, // Принудительно подсвечиваем границу поля
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: generalError != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            generalError!,
                            style: context.text.bodyText14White
                                .copyWith(color: Colors.red),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                TextButton(
                  onPressed: () {
                    widget.pageController.animateToPage(2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: Text(
                    tr('sign_in_page.forgot_password_link'),
                    style: context.text.bodyText12Grey.copyWith(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoading) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is AuthAuthenticated) {
                      Navigator.of(context).pop(); // Закрываем окно загрузки
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CustomBottomNavigationBar()),
                      );
                    } else if (state is AuthError) {
                      Navigator.of(context).pop(); // Закрываем окно загрузки

                      // Если ошибка связана с неправильным логином или паролем
                      if (state.message.contains('400')) {
                        setState(() {
                          generalError = tr('sign_in_page.login_error');
                        });
                      }
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: tr('sign_in_page.login_button'),
                      onPressed: () {
                        _onSubmit(context); // Валидация и отправка
                      },
                      single: true,
                    );
                  },
                ),
                const SizedBox(height: 24.0),
                TextWithLines(text: tr('sign_in_page.alternative_sign_in')),
                const SizedBox(height: 24),
                // RegistrationServicesButton(
                //   text: tr('sign_in_page.apple_id_button'),
                //   onPressed: () {},
                // ),
                const SizedBox(height: 12),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthGoogleLoading) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is AuthAuthenticated) {
                      // Закрываем окно загрузки
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CustomBottomNavigationBar()),
                      );
                    } else if (state is AuthGoogleError) {
                      print('google error');
                      Navigator.of(context).pop(); // Закрываем окно загрузки
                      setState(() {
                        generalError =
                            state.message; // Сообщение об ошибке для Google
                      });
                    } else if (state is AuthUnauthenticated) {}
                  },
                  builder: (context, state) {
                    return RegistrationServicesButton(
                      text: tr('sign_in_page.google_button'),
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(SignInWithGoogleRequested());
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                // RegistrationServicesButton(
                //   text: tr('sign_in_page.facebook_button'),
                //   onPressed: () {},
                // ),
                const SizedBox(height: 24.0),
                TextButton(
                  onPressed: () {
                    widget.pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: Text(tr('sign_in_page.register_link'),
                      style: context.text.bodyText16White),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
