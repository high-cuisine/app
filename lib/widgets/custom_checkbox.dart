import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCircularCheckbox extends StatelessWidget {
  final bool isChecked; // Параметр для внешнего управления состоянием
  final ValueChanged<bool> onChanged; // Колбэк для обработки нажатий

  const CustomCircularCheckbox({
    required this.isChecked,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isChecked); // Изменение состояния через колбэк
      },
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? const Color(0xFFF6B402) : Colors.transparent,
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: isChecked
            ? Center(
                child: SvgPicture.asset(
                  'assets/images/check.svg',
                  width: 7,
                  height: 7,
                ),
              )
            : null,
      ),
    );
  }
}

class CustomCheckboxListTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckboxListTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value), // Обработка нажатия на всю область
      child: ListTile(
        leading: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                value ? const Color(0xFFF6B402) : Colors.white.withOpacity(0.2),
          ),
          child: value
              ? Center(
                  child: SvgPicture.asset(
                    'assets/images/check.svg',
                    width: 7,
                    height: 7,
                  ),
                )
              : null,
        ),
        title: Text(title, style: context.text.bodyText14White),
      ),
    );
  }
}
