import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:rive/rive.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

import 'package:utpl_totem/app/presentation/modules/screen_protector/screen_protector_controller.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

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
                          padding:
                              EdgeInsets.only(right: ctrl.responsive.wp(2)),
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
                                  color: ctrl.colorContent,
                                  fontWeight: FontWeight.bold,
                                ),
                                secondDigitTextStyle: TextStyle(
                                  fontSize: ctrl.responsive.ip(3),
                                  color: ctrl.colorContent,
                                  fontWeight: FontWeight.bold,
                                ),
                                showSecondsDigit: false,
                                amPmDigitTextStyle: TextStyle(
                                  color: ctrl.colorContent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ctrl.responsive.ip(4),
                                ),
                                colon: Text(
                                  ':',
                                  style: TextStyle(
                                    fontSize: ctrl.responsive.ip(3.5),
                                    color: ctrl.colorContent,
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
                          height: ctrl.responsive.hp(26),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                //width: ctrl.responsive.wp(10),
                                height: ctrl.responsive.hp(7),
                                child: const RiveAnimation.asset(
                                  alignment: Alignment.center,
                                  'assets/rive/logo_utpl.riv',
                                  animations: ['entry'],
                                ),
                              ),
                              SizedBox(
                                height: ctrl.responsive.hp(9),
                              ),
                            ],
                          ),
                        ),
                        // CONTENT DYNAMIC
                        // Divider(
                        //   color: Get.theme.colorScheme.tertiary,
                        //   height: ctrl.responsive.hp(0.5),
                        //   thickness: ctrl.responsive.hp(0.5),
                        // ),
                        ctrl.wallpaper.value.title != ''
                            ? Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ctrl.wallpaper.value.title,
                                      style: TextStyle(
                                        fontSize: ctrl.responsive.ip(3.2),
                                        color: ctrl.colorContent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(
                                        UtplCustom.right_small_arrow,
                                        size: ctrl.responsive.ip(3),
                                        color: ctrl.colorContent,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
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
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          height: ctrl.responsive.hp(35),
                                          imageUrl:
                                              ctrl.wallpaper.value.image?.url ??
                                                  '',
                                          fit: BoxFit.contain,
                                          errorWidget: (context, a, b) {
                                            return Image.asset(
                                                'assets/images/logo-utpl-full.png');
                                          },
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/images/logo-utpl-full.png'),
                                        ),
                                      ],
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
                                            ctrl.wallpaper.value.description,
                                            style: TextStyle(
                                              fontSize: ctrl.responsive.ip(2),
                                              color: ctrl.colorContent,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ctrl.wallpaper.value.link?.url != ''
                                        ? Expanded(
                                            child: Container(
                                              color:
                                                  Get.theme.colorScheme.primary,
                                              child: Center(
                                                child: Card(
                                                  color: ctrl.colorContent,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical:
                                                          ctrl.responsive.hp(1),
                                                      horizontal:
                                                          ctrl.responsive.wp(2),
                                                    ),
                                                    child: PrettyQr(
                                                      //image: const AssetImage('assets/images/logo_utpl_azul.png'),
                                                      elementColor:
                                                          Colors.black,
                                                      typeNumber: null,
                                                      size: ctrl.responsive
                                                          .ip(13),
                                                      data: ctrl.wallpaper.value
                                                              .link?.url ??
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
                                        : const SizedBox(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        customYMargin(ctrl.responsive.hp(2)),
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
                                    color: Get.theme.colorScheme.tertiary,
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
                                    color: Get.theme.colorScheme.tertiary,
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
