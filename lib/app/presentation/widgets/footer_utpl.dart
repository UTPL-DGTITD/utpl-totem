import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/themes/responsive.dart';

class FooterUTPL extends StatelessWidget {
  const FooterUTPL({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();
    return Container(
      color: Get.theme.colorScheme.primary,
      width: double.infinity,
      height: responsive.hp(7),
      child: Center(
        child: Text(
          'Tótem UTPL+ powered by DGTI & TD',
          style: TextStyle(
            fontSize: responsive.ip(2),
            color: Get.theme.cardColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
