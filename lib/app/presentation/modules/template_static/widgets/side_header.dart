import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:gauge_indicator/gauge_indicator.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:utpl_totem/app/presentation/modules/template_static/template_static_controller.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

class SideHeader extends StatelessWidget {
  final TemplateStaticController ctrl;
  const SideHeader({
    Key? key,
    required this.ctrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ctrl.responsive.hp(1),
        horizontal: ctrl.responsive.wp(1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${ctrl.weather?.value.day}',
                  style: TextStyle(
                    fontSize: ctrl.responsive.ip(2.4),
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Clock(ctrl: ctrl),
                const Divider(),
                Text(
                  'Temperatura', //${ctrl.currentUv}
                  style: TextStyle(
                    fontSize: ctrl.responsive.ip(1.7),
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Obx(
                  () => Text(
                    '${ctrl.currentTemp.value}ºC',
                    style: Get.textTheme.headline6?.copyWith(
                      fontSize: ctrl.responsive.ip(2.5),
                      fontWeight: FontWeight.bold,
                      color: Get.theme.cardColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Mín\n${ctrl.weather?.value.tempMin}ºC',
                        style: Get.textTheme.headline6?.copyWith(
                          fontSize: ctrl.responsive.ip(1.6),
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Máx\n${ctrl.weather?.value.tempMax}ºC',
                        style: Get.textTheme.headline6?.copyWith(
                          fontSize: ctrl.responsive.ip(1.6),
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                Center(
                  child: SvgPicture.asset(
                    int.parse(ctrl.weather!.value.tempMax ?? '0') <= 20
                        ? 'assets/svg/rain.svg'
                        : int.parse(ctrl.weather!.value.tempMax ?? '0') >= 26
                            ? 'assets/svg/sunny.svg'
                            : 'assets/svg/cloudy.svg',
                    width: ctrl.responsive.ip(9),
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
                Obx(
                  () => Text(
                    ctrl.currentDescTemp.value,
                    style: TextStyle(
                      fontSize: ctrl.responsive.ip(1.6),
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(),
                Text(
                  'Índice UV', //${ctrl.currentUv}
                  style: TextStyle(
                    fontSize: ctrl.responsive.ip(1.7),
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                customYMargin(ctrl.responsive.hp(1)),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ctrl.responsive.wp(0)),
                      width: double.infinity,
                      child: Obx(
                        () => AnimatedRadialGauge(
                          builder: (context, child, value) => Text(
                            ctrl.currentUv.value,
                            style: TextStyle(
                              fontSize: ctrl.responsive.ip(2),
                              color: Get.theme.cardColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          /// The animation duration.
                          duration: const Duration(seconds: 1),
                          curve: Curves.elasticOut,

                          /// Gauge value.
                          value: double.parse(ctrl.currentUv.value),
                          // progressBar: const GaugeRoundedProgressBar(
                          //   color: Color(0xFFB4C2F8),
                          // ),

                          axis: GaugeAxis(
                            pointer: RoundedTrianglePointer(
                              size: ctrl.responsive.ip(1.5),
                              backgroundColor: Get.theme.colorScheme.primary,
                              position: const GaugePointerPosition.surface(
                                offset: Offset(0, 20 * 0.6),
                              ),
                            ),
                            min: 0,
                            max: 15,

                            /// Render the gauge as a 180-degree arc.
                            degrees: 180,

                            /// Set the background color and axis thickness.
                            style: GaugeAxisStyle(
                              segmentSpacing: 0,
                              blendColors: true,
                              thickness: ctrl.responsive.wp(3),
                              background: Colors.green,
                            ),
                            segments: const [
                              GaugeSegment(
                                from: 0,
                                to: 2,
                                color: Colors.green,
                              ),
                              GaugeSegment(
                                from: 2,
                                to: 5,
                                color: Colors.yellow,
                              ),
                              GaugeSegment(
                                from: 5,
                                to: 7,
                                color: Colors.orange,
                              ),
                              GaugeSegment(
                                from: 7,
                                to: 10,
                                color: Colors.red,
                              ),
                              GaugeSegment(
                                from: 10,
                                to: 15,
                                color: Colors.purple,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        ctrl.currentDescUv.value,
                        style: TextStyle(
                          fontSize: ctrl.responsive.ip(2),
                          color: Get.theme.cardColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BottomLink(
                  ctrl: ctrl,
                  text: 'Noticias',
                  onTap: () => ctrl.navigateToPage(Routes.news),
                ),
                customYMargin(ctrl.responsive.hp(1)),
                BottomLink(
                  ctrl: ctrl,
                  text: 'Eventos',
                  onTap: () => ctrl.navigateToPage(Routes.events),
                ),
                customYMargin(ctrl.responsive.hp(2)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  color: Get.theme.colorScheme.tertiary,
                  child: PrettyQr(
                    //image: const AssetImage('assets/images/logo_utpl_azul.png'),
                    elementColor: Colors.black,
                    typeNumber: null,
                    size: ctrl.responsive.ip(11),
                    data: 'https://smartland.utpl.edu.ec/',
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    roundEdges: true,
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

class BottomLink extends StatelessWidget {
  final String text;
  final Function onTap;

  const BottomLink({
    super.key,
    required this.ctrl,
    required this.text,
    required this.onTap,
  });

  final TemplateStaticController ctrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text,
              style: TextStyle(
                fontSize: ctrl.responsive.ip(1.8),
                color: Get.theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                UtplCustom.right_small_arrow,
                size: ctrl.responsive.ip(2.5),
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Clock extends StatelessWidget {
  const Clock({
    Key? key,
    required this.ctrl,
  }) : super(key: key);

  final TemplateStaticController ctrl;

  @override
  Widget build(BuildContext context) {
    return DigitalClock(
      is24HourTimeFormat: true,
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
      showSecondsDigit: false,
      amPmDigitTextStyle: TextStyle(
        color: Get.theme.colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: ctrl.responsive.ip(1.2),
      ),
      colon: Text(
        ':',
        style: TextStyle(
          fontSize: ctrl.responsive.ip(3),
          color: Get.theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
