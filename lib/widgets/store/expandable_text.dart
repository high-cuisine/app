import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String titleText;
  final String text;

  const ExpandableTextWidget({
    Key? key,
    required this.text,
    required this.titleText,
  }) : super(key: key);

  @override
  ExpandableTextWidgetState createState() => ExpandableTextWidgetState();
}

class ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;
  bool isExpandable = false;
  int maxLines = 4; // Количество строк до расширения

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfTextIsExpandable();
    });
  }

  // Метод для проверки, сколько строк занимает текст
  void _checkIfTextIsExpandable() {
    final textSpan = TextSpan(
      text: widget.text,
      style: context.text.bodyText12Grey.copyWith(fontSize: 16, height: 1.5),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: MediaQuery.of(context).size.width - 32, // Учитываем паддинг
    );

    // Проверяем, если текст превышает maxLines строк
    if (textPainter.didExceedMaxLines) {
      setState(() {
        isExpandable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (isExpandable) {
              setState(() {
                isExpanded = !isExpanded;
              });
            }
          },
          splashColor: Colors.transparent, // Отключаем белый отклик
          highlightColor: Colors.transparent, // Отключаем подсветку при нажатии
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.titleText,
              style: context.text.bodyText16White
                  .copyWith(fontSize: 18), // Ваш стиль текста
            ),
            trailing: isExpandable
                ? Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    color: Colors.white,
                  )
                : null, // Показываем иконку только если текст можно развернуть
          ),
        ),
        Text(
          widget.text,
          maxLines: isExpanded ? null : maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style:
              context.text.bodyText12Grey.copyWith(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }
}
