import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/standart_auth_bloc/standart_auth_bloc.dart';
import '../../widgets/auth/center_text.dart';
import '../../widgets/auth/custom_auth_textfield.dart';
import '../../widgets/base_pop_up.dart';
import '../../widgets/custom_button.dart';

class RegistrationPage4 extends StatelessWidget {
  final PageController pageController;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String gender;
  final String dateOfBirth;
  final String referralCode;

  const RegistrationPage4({
    super.key,
    required this.pageController,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.referralCode,
  });

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    String? passwordError;
    String? confirmPasswordError;
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BasePopup(
          text: tr('registration_page.password_title'),
          onPressed: () {
            pageController.animateToPage(2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CenterText(
                    text: tr('registration_page.create_password_description'),
                    padding: 60,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    labelText: tr('registration_page.password_label'),
                    obscureText: true,
                    controller: passwordController,
                    isJoined: true,
                    joinPosition: JoinPosition.top,
                    errorMessage: passwordError,
                  ),
                  CustomTextField(
                    labelText: tr('registration_page.confirm_password_label'),
                    obscureText: true,
                    controller: confirmPasswordController,
                    isJoined: true,
                    joinPosition: JoinPosition.bottom,
                    errorMessage: confirmPasswordError,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: tr('registration_page.register_button'),
                    gradient: true,
                    onPressed: () {
                      final password = passwordController.text;
                      final confirmPassword = confirmPasswordController.text;

                      setState(() {
                        passwordError = null;
                        confirmPasswordError = null;
                      });

                      if (password.isEmpty) {
                        setState(() {
                          passwordError =
                              tr('registration_page.password_error');
                        });
                      } else if (password.length < 8 ||
                          !passwordRegex.hasMatch(password)) {
                        setState(() {
                          passwordError =
                              tr('registration_page.password_too_short_error');
                        });
                      }

                      if (confirmPassword.isEmpty) {
                        setState(() {
                          confirmPasswordError =
                              tr('registration_page.confirm_password_error');
                        });
                      } else if (password != confirmPassword) {
                        setState(() {
                          confirmPasswordError =
                              tr('registration_page.password_mismatch_error');
                        });
                      }

                      if (passwordError == null &&
                          confirmPasswordError == null) {
                        context.read<AuthBloc>().add(
                              RegisterRequested(
                                firstName: firstName,
                                lastName: lastName,
                                phone: phone,
                                gender: gender,
                                dateOfBirth: dateOfBirth,
                                password: password,
                                email: email,
                                refCode: referralCode,
                              ),
                            );
                        pageController.animateToPage(4,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    single: true,
                  ),
                  const SizedBox(height: 15),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
