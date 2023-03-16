import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:rive/rive.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import 'package:utpl_totem/app/presentation/modules/screen_protector/screen_protector_controller.dart';

class ScreenProtectorPage extends GetView<ScreenProtectorController> {
  const ScreenProtectorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<ScreenProtectorController>(
        init: ScreenProtectorController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return ctrl.showSkeleton.isFalse
              ? GestureDetector(
                  onTap: () => controller.exitScreenProtector(),
                  onPanDown: (_) => controller.exitScreenProtector(),
                  onTapDown: (_) => controller.exitScreenProtector(),
                  child: Container(
                    color: Get.theme.colorScheme.primary,
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: ctrl.responsive.hp(10),
                          color: Get.theme.colorScheme.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DigitalClock(
                                //areaAligment: AlignmentDirectional.topEnd,
                                is24HourTimeFormat: true,
                                areaDecoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                minuteDigitDecoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                hourMinuteDigitTextStyle: TextStyle(
                                  fontSize: ctrl.responsive.ip(4.5),
                                  color: Get.theme.cardColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                secondDigitTextStyle: TextStyle(
                                  fontSize: ctrl.responsive.ip(3),
                                  color: Get.theme.cardColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                showSecondsDigit: false,
                                amPmDigitTextStyle: TextStyle(
                                  color: Get.theme.cardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ctrl.responsive.ip(4),
                                ),
                                colon: Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: ctrl.responsive.ip(3.5),
                                    color: Get.theme.cardColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // STATIC HEADER
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ctrl.responsive.hp(1)),
                          width: double.infinity,
                          //color: Colors.green,
                          height: ctrl.responsive.hp(30),
                          child: Center(
                            child: SizedBox(
                              width: ctrl.responsive.wp(50),
                              child: const RiveAnimation.asset(
                                alignment: Alignment.center,
                                'assets/rive/logo_utpl.riv',
                                animations: ['entry'],
                              ),
                            ),
                          ),
                        ),
                        // CONTENT DYNAMIC
                        Divider(
                          color: Get.theme.colorScheme.tertiary,
                          height: ctrl.responsive.hp(0.5),
                          thickness: ctrl.responsive.hp(0.5),
                        ),
                        Container(
                          width: double.infinity,
                          height: ctrl.responsive.hp(40),
                          color: Get.theme.colorScheme.primary,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Get.theme.colorScheme.primary,
                                  child: Center(
                                    child: Image(
                                      image: const AssetImage(
                                          'assets/images/intro/intro_page_3.png'),
                                      width: ctrl.responsive.wp(70),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: ctrl.responsive.hp(1),
                                          horizontal: ctrl.responsive.wp(1.5),
                                        ),
                                        color: Get.theme.colorScheme.primary,
                                        child: Center(
                                          child: Text(
                                            'La aplicación UTPL+ te ofrece una amplia gama de funcionalidades que te permitirán tener todo lo que necesitas. \n!Descárgala ya!',
                                            style: TextStyle(
                                              fontSize: ctrl.responsive.ip(2),
                                              color: Get.theme.cardColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Get.theme.colorScheme.primary,
                                        child: Center(
                                          child: Card(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: ctrl.responsive.hp(1),
                                                horizontal:
                                                    ctrl.responsive.wp(2),
                                              ),
                                              child: PrettyQr(
                                                //image: const AssetImage('assets/images/logo_utpl_azul.png'),
                                                elementColor: Colors.black,
                                                typeNumber: null,
                                                size: ctrl.responsive.ip(13),
                                                data:
                                                    'https://appmovil.utpl.edu.ec/',
                                                errorCorrectLevel:
                                                    QrErrorCorrectLevel.M,
                                                roundEdges: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Get.theme.colorScheme.tertiary,
                          height: ctrl.responsive.hp(0.5),
                          thickness: ctrl.responsive.hp(0.5),
                        ),
                        Container(
                          width: double.infinity,
                          height: ctrl.responsive.hp(15),
                          color: Get.theme.colorScheme.primary,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Touch me...',
                                  style: TextStyle(
                                    fontSize: ctrl.responsive.ip(3),
                                    color: Get.theme.cardColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Pulse(
                                  infinite: true,
                                  delay: const Duration(seconds: 1),
                                  animate: true,
                                  manualTrigger: false,
                                  duration: const Duration(seconds: 1),
                                  child: Icon(
                                    Icons.touch_app,
                                    size: ctrl.responsive.ip(5),
                                    color: Get.theme.cardColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
