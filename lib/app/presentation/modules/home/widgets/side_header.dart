import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_controller.dart';

class SideHeader extends StatelessWidget {
  final HomeController ctrl;
  const SideHeader({
    Key? key,
    required this.ctrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ctrl.responsive.hp(1),
        // horizontal: ctrl.responsive.wp(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'UTPL+',
              style: TextStyle(
                color: Get.theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: ctrl.responsive.ip(3),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: DigitalClock(
                    is24HourTimeFormat: false,
                    areaDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    areaAligment: AlignmentDirectional.center,
                    minuteDigitDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    hourMinuteDigitTextStyle: TextStyle(
                      fontSize: ctrl.responsive.ip(2.5),
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    secondDigitTextStyle: TextStyle(
                      fontSize: ctrl.responsive.ip(1),
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    showSecondsDigit: true,
                    amPmDigitTextStyle: TextStyle(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: ctrl.responsive.ip(1.2),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${ctrl.weather!.value.day}',
                    style: TextStyle(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: ctrl.responsive.ip(2.2),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      int.parse(ctrl.weather!.value.tempMax ?? '0') <= 20
                          ? Expanded(
                              child: Image.asset(
                                'assets/images/nube.png',
                                scale: ctrl.responsive.ip(0.9),
                                color: Get.theme.cardColor,
                              ),
                            )
                          : int.parse(ctrl.weather!.value.tempMax ?? '0') >= 26
                              ? Expanded(
                                  child: Image.asset(
                                    'assets/images/sol.png',
                                    scale: ctrl.responsive.ip(0.8),
                                    color: Get.theme.cardColor,
                                  ),
                                )
                              : Expanded(
                                  child: Image.asset(
                                      'assets/images/solnube.png',
                                      scale: ctrl.responsive.ip(0.5),
                                      color: Get.theme.cardColor),
                                ),
                      Expanded(
                        child: Text(
                          '${ctrl.currentTemp}ºC',
                          style: TextStyle(
                            color: Get.theme.cardColor,
                            fontWeight: FontWeight.bold,
                            fontSize: ctrl.responsive.ip(2.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    'Temp min: ${ctrl.weather!.value.tempMin ?? ''}ºC',
                    style: TextStyle(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: ctrl.responsive.ip(1.4),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Temp máx: ${ctrl.weather!.value.tempMax ?? ''}ºC',
                    style: TextStyle(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: ctrl.responsive.ip(1.4),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Get.theme.cardColor,
                //     ),
                //     padding: EdgeInsets.symmetric(
                //       horizontal: ctrl.responsive.wp(6),
                //       vertical: ctrl.responsive.hp(2),
                //     ),
                //     width: double.maxFinite,
                //     margin: EdgeInsets.symmetric(
                //       horizontal: ctrl.responsive.wp(2),
                //     ),
                //     child: MaterialButton(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       elevation: 0,
                //       color: Get.theme.colorScheme.tertiary,
                //       child: Text(
                //         'Recargar',
                //         style: Get.textTheme.headline5?.copyWith(
                //           fontSize: ctrl.responsive.ip(1.5),
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //       onPressed: () {
                //         ctrl.validateCode();
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: ctrl.responsive.ip(2.5),
                ),
                Expanded(
                  child: Text(
                    '${ctrl.currentTemplate.value.title} - ${ctrl.currentTemplate.value.tvTemplateHeader!.title}',
                    style: Get.textTheme.headline6?.copyWith(
                      fontSize: ctrl.responsive.ip(1.4),
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
