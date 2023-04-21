import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:utpl_totem/app/presentation/modules/template_offline/template_offline_controller.dart';

class SideHeader extends StatelessWidget {
  final TemplateOfflineController ctrl;
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
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // Icon(
                //   Icons.location_on,
                //   size: ctrl.responsive.ip(2.5),
                // ),
                Expanded(
                  child: Text(
                    'Decide ser más',
                    style: Get.textTheme.titleLarge?.copyWith(
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
