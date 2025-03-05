import 'package:flutter/material.dart';

import 'package:rive/rive.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/splash_screen/splash_screen_controller.dart';
import 'package:utpl_totem_oficial/app/themes/app_theme.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';

class SplashScreenPage extends GetView<SplashScreenController> {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: LightSchema.primaryColor,
        ),
        child: Center(
          child: SizedBox(
            width: responsive.wp(50),
            child: const RiveAnimation.asset(
              'assets/rive/logo_utpl.riv',
              animations: ['entry'],
            ),
          ),
        ),
      ),
    );
  }
}
