import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

class FloatBackButton extends StatelessWidget {
  const FloatBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();
    return Stack(
      children: [
        Positioned(
          bottom: responsive.hp(5),
          left: responsive.wp(33.5),
          child: Container(
            width: responsive.wp(33),
            height: responsive.hp(6),
            child: FloatingActionButton.extended(
              backgroundColor: Get.theme.colorScheme.tertiary,
              onPressed: () => Get.back(),
              label: Text(
                'Volver',
                style: TextStyle(
                  color: Get.theme.colorScheme.primary,
                  fontSize: responsive.ip(2.5),
                ),
              ),
              icon: Icon(
                UtplCustom.left_small_arrow,
                color: Get.theme.colorScheme.primary,
                size: responsive.ip(3.5),

                //size: controller.responsive.ip(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
