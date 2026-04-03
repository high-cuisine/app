import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SolidAddPhotoButton extends StatelessWidget {
  final Function() onTap;

  const SolidAddPhotoButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 70, // Высота кнопки
        width: 70, // Ширина кнопки (можно настроить под нужные размеры)
        decoration: BoxDecoration(
          color: Colors.transparent, // Прозрачный фон
          borderRadius: BorderRadius.circular(12), // Закругленные углы
          border: Border.all(
            color: Colors.white.withOpacity(0.0), // Цвет рамки
            style: BorderStyle.solid, // Тип границы (solid или пунктир)
          ),
          shape: BoxShape.rectangle,
        ),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(10),
          // Закругленные углы
          dashPattern: [3, 3],
          // Настройка пунктирной линии: длина и отступы
          color: Colors.white.withOpacity(0.3),
          // Цвет пунктиров
          strokeWidth: 1,
          // Толщина пунктиров
          child: Center(
            child: SvgPicture.asset(
              'assets/images/krest.svg', // Путь к SVG файлу
              width: 17, // Размер иконки
              height: 17,
              color: Colors.white, // Цвет иконки
            ),
          ),
        ),
      ),
    );
  }
}
