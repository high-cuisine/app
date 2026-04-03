import 'package:cocktails/theme/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum JoinPosition { none, top, bottom }

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final bool isJoined;
  final bool phoneNumber;
  final JoinPosition joinPosition;
  final TextEditingController? controller;
  final bool isReferral;
  final bool isDate;
  final String? errorMessage;
  final bool expandText;
  final bool showRedBorder;
  final ValueChanged<String>? onChanged; // Добавляем параметр onChanged

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.isJoined = false,
    this.phoneNumber = false,
    this.joinPosition = JoinPosition.none,
    this.controller,
    this.isReferral = false,
    this.isDate = false,
    this.errorMessage,
    this.expandText = false,
    this.showRedBorder = false,
    this.onChanged, // Инициализируем onChanged
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _showReferralInfo = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleReferralInfo() {
    setState(() {
      _showReferralInfo = !_showReferralInfo;
    });
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      widget.controller?.text = DateFormat('dd.MM.yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (widget.isJoined) {
      if (widget.joinPosition == JoinPosition.top) {
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        );
      } else if (widget.joinPosition == JoinPosition.bottom) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0x05FFFFFF),
            borderRadius: borderRadius,
            border: Border.all(
              color: (widget.errorMessage != null || widget.showRedBorder)
                  ? Colors.red
                  : const Color(0xFF343434),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 4.0), // Уменьшенный padding
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    obscureText: _obscureText,
                    maxLines: widget.expandText ? null : 1,
                    minLines: 1,
                    keyboardType: widget.phoneNumber
                        ? TextInputType.phone
                        : TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: widget.onChanged,
                    onTap: widget.isDate ? () => _selectDate(context) : null,
                  ),
                ),
                if (widget.obscureText)
                  Transform.translate(
                    offset: const Offset(0, 4),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        _obscureText
                            ? 'assets/images/hide_password.svg'
                            : 'assets/images/show_password.svg',
                        width: 14,
                        height: 14,
                      ),
                      onPressed: _togglePasswordVisibility,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                if (widget.isReferral)
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/referal.svg',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: _toggleReferralInfo,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorMessage != null && widget.showRedBorder == false)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 16.0),
            child: Text(
              widget.errorMessage!,
              style: context.text.bodyText12Grey.copyWith(color: Colors.red),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        else if (widget.showRedBorder == true)
          const SizedBox(),
        if (_showReferralInfo)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('registration_page.referral_code_label'),
                      style: context.text.bodyText12Grey.copyWith(
                          color: const Color(0xffF6B402), fontSize: 15),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      tr('registration_page.referral_code_description'),
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
