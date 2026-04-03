import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../custom_checkbox.dart';

class UserAgreement extends StatefulWidget {
  final String text;
  final String clickText;
  final VoidCallback
      onClickText; // Новый параметр для обработки клика по тексту
  final Function(bool) onCheckChanged;

  const UserAgreement({
    super.key,
    required this.text,
    required this.clickText,
    required this.onCheckChanged,
    required this.onClickText, // Передаем функцию для обработки клика
  });

  @override
  UserAgreementState createState() => UserAgreementState();
}

class UserAgreementState extends State<UserAgreement> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
              widget.onCheckChanged(isChecked);
            });
          },
          child: CustomCircularCheckbox(
            isChecked: isChecked,
            onChanged: (checked) {
              setState(() {
                isChecked = checked;
                widget.onCheckChanged(isChecked);
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: widget.text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: widget.clickText,
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickText, // Обрабатываем клик по тексту
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
