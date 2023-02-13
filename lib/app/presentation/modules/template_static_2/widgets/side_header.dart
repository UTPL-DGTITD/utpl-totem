import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:utpl_totem/app/presentation/modules/template_static_2/template_static_controller.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SideHeader extends StatelessWidget {
  final TemplateStaticController2 ctrl;
  const SideHeader({
    Key? key,
    required this.ctrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Completer<WebViewController> controller =
    //     Completer<WebViewController>();
    // final Completer<WebViewController> controller2 =
    //     Completer<WebViewController>();
    // final Completer<WebViewController> controller3 =
    //     Completer<WebViewController>();
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ctrl.responsive.hp(1),
        // horizontal: ctrl.responsive.wp(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    '21 ºC',
                    style: Get.textTheme.headline6?.copyWith(
                      fontSize: ctrl.responsive.ip(4),
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Clock(ctrl: ctrl),
                const Divider(),
              ],
            ),
          ),
          // Expanded(
          //     flex: 4,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Container(
          //           width: double.infinity,
          //           height: ctrl.responsive.hp(15),
          //           color: Colors.red,
          //           child: WebView(
          //             zoomEnabled: true,
          //             initialUrl:
          //                 'https://www.weatherlink.com/embeddablePage/show/6b0ea9ae24364e1192d658baabca9c21/slim',
          //             javascriptMode: JavascriptMode.unrestricted,
          //             onWebViewCreated: (WebViewController webViewController) {
          //               controller.complete(webViewController);
          //             },
          //           ),
          //         ),
          //         customYMargin(ctrl.responsive.hp(2)),
          //         Container(
          //           width: double.infinity,
          //           height: ctrl.responsive.hp(15),
          //           color: Colors.red,
          //           child: WebView(
          //             zoomEnabled: true,
          //             initialUrl: 'https://arcg.is/14zfK1',
          //             javascriptMode: JavascriptMode.unrestricted,
          //             onWebViewCreated: (WebViewController webViewController) {
          //               controller2.complete(webViewController);
          //             },
          //           ),
          //         ),
          //         customYMargin(ctrl.responsive.hp(2)),
          //         Container(
          //           width: double.infinity,
          //           height: ctrl.responsive.hp(15),
          //           color: Colors.red,
          //           child: WebView(
          //             zoomEnabled: true,
          //             initialUrl: 'https://arcg.is/0ie5Hy',
          //             javascriptMode: JavascriptMode.unrestricted,
          //             onWebViewCreated: (WebViewController webViewController) {
          //               controller3.complete(webViewController);
          //             },
          //           ),
          //         ),
          //       ],
          //     )),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // customYMargin(ctrl.responsive.hp(30)),
                Container(
                  alignment: Alignment.bottomCenter,
                  color: Get.theme.colorScheme.tertiary,
                  child: PrettyQr(
                    image: const AssetImage('assets/images/logo_utpl_azul.png'),
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

class Clock extends StatelessWidget {
  const Clock({
    Key? key,
    required this.ctrl,
  }) : super(key: key);

  final TemplateStaticController2 ctrl;

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
        fontSize: ctrl.responsive.ip(3),
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
    );
  }
}
