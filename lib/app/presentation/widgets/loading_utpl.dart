import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';

class LoadingUtpl extends StatelessWidget {
  const LoadingUtpl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();
    return Container(
      color: Get.theme.cardColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              //color: Get.theme.canvasColor,
              height: responsive.hp(30),
              child: Center(
                child: SizedBox(
                  width: responsive.wp(50),
                  child: const RiveAnimation.asset(
                    'assets/rive/logo_utpl_loading.riv',
                    animations: ['entry'],
                  ),
                ),
              ),
            ),
            Text(
              'Cargando...',
              style: TextStyle(
                fontSize: responsive.ip(2),
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
