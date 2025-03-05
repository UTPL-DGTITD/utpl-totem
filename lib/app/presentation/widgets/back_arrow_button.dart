import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';

class BackArrowButton extends StatelessWidget {
  final Color? color;

  const BackArrowButton({
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();

    return Padding(
      padding: EdgeInsets.all(responsive.ip(1)),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            UtplCustom.left_small_arrow,
            size: responsive.ip(3),
            color: Get.theme.colorScheme.primary,
          ),
        ),
        onTap: () => Get.back(),
      ),
    );
  }
}
