import 'dart:math' as math;

import 'package:get/get.dart';

class Responsive {
  double width = 0, height = 0, inch = 0;

  Responsive() {
    final size = Get.mediaQuery.size;

    width = size.width;
    height = size.height;

    inch = math.sqrt(math.pow(width, 2) + math.pow(height, 2));
  }

  double wp(double percent) {
    return width * percent / 100;
  }

  double hp(double percent) {
    return height * percent / 100;
  }

  double ip(double percent) {
    return inch * percent / 100;
  }
}
