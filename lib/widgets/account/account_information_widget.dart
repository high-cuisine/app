import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum JoinPosition { none, top, bottom }

class AccountInformationWidget extends StatelessWidget {
  final String labelText;
  final String infoText;
  final JoinPosition joinPosition;
  final bool isJoined;
  final TextEditingController? controller;
  final bool editable;
  final bool readOnly;
  final VoidCallback? onTap;

  const AccountInformationWidget(
      {super.key,
      required this.labelText,
      required this.infoText,
      required this.joinPosition,
      required this.isJoined,
      this.controller,
      this.editable = false,
      this.readOnly = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (isJoined) {
      if (joinPosition == JoinPosition.top) {
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        );
      } else if (joinPosition == JoinPosition.bottom) {
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        );
      } else {
        borderRadius = BorderRadius.zero;
      }
    } else {
      borderRadius = BorderRadius.circular(10.0);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0x05FFFFFF),
            borderRadius: borderRadius,
            border: Border.all(color: const Color(0xFF343434), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 14.0, right: 8.0, bottom: 14.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                labelText,
                style: context.text.bodyText12Grey,
              ),
              const SizedBox(height: 6),
              if (editable && controller != null)
                CupertinoTextField(
                  controller: controller,
                  readOnly: readOnly,
                  onTap: onTap,
                  placeholder: infoText,
                  style: context.text.bodyText16White,
                  placeholderStyle: context.text.bodyText16White
                      .copyWith(color: Colors.white.withOpacity(0.45)),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                )
              else
                Text(
                  infoText,
                  style: context.text.bodyText16White,
                ),
            ]),
          ),
        )
      ],
    );
  }
}
