import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const CustomSwitch({
    required this.value,
    required this.onChanged,
    required this.activeColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      value: value,
      onToggle: onChanged,
      height: 30,
      toggleSize: 25,
      padding: 2.0,
      width: 60,
      activeColor: const Color(0xffF6B402),
      inactiveColor: const Color(0xff343434),
      activeToggleColor: const Color(0xffFFFFFF),
      inactiveToggleColor: const Color(0xffB7B7B7),
    );
  }
}
