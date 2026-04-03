import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class GradientBorderSwitch extends StatefulWidget {
  final Function(String)
      onGenderChanged; // Добавим коллбэк для передачи выбранного пола

  const GradientBorderSwitch({super.key, required this.onGenderChanged});

  @override
  GradientBorderSwitchState createState() => GradientBorderSwitchState();
}

class GradientBorderSwitchState extends State<GradientBorderSwitch> {
  int _selectedIndex = 0; // 0 - мужской, 1 - женский

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: _buildButton(0, tr('registration_page.male_option'))),
        // Локализованный текст
        Expanded(child: _buildButton(1, tr('registration_page.female_option'))),
        // Локализованный текст
      ],
    );
  }

  Widget _buildButton(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          widget.onGenderChanged(_selectedIndex == 0
              ? 'Male'
              : 'Female'); // Передаем значение выбранного пола
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(index == 0 ? 11 : 0),
            bottomLeft: Radius.circular(index == 0 ? 11 : 0),
            topRight: Radius.circular(index == 1 ? 11 : 0),
            bottomRight: Radius.circular(index == 1 ? 11 : 0),
          ),
          border: GradientBoxBorder(
            gradient: _selectedIndex == index
                ? const LinearGradient(
                    colors: [
                      Color(0xFFF8C82C),
                      Color(0xFFEF7F31),
                      Color(0xFFDD66A9),
                    ],
                  )
                : const LinearGradient(
                    colors: [Color(0xff343434), Color(0xff343434)],
                  ),
            width: 2,
          ),
        ),
        child: Container(
          width: 100,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(index == 0 ? 10 : 0),
              bottomLeft: Radius.circular(index == 0 ? 10 : 0),
              topRight: Radius.circular(index == 1 ? 10 : 0),
              bottomRight: Radius.circular(index == 1 ? 10 : 0),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: _selectedIndex == index
                  ? Colors.white
                  : const Color(0xffB7B7B7),
            ),
          ),
        ),
      ),
    );
  }
}
