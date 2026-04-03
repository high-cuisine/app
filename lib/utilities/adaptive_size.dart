import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultWidth;
  static late double defaultHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  void init(BuildContext context, {double width = 393, double height = 852}) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    defaultWidth = width;
    defaultHeight = height;
    blockSizeHorizontal = screenWidth / defaultWidth;
    blockSizeVertical = screenHeight / defaultHeight;
  }

  static double heightAdaptive(double size) {
    return size * blockSizeVertical;
  }

  static double widthAdaptive(double size) {
    return size * blockSizeHorizontal;
  }
}
