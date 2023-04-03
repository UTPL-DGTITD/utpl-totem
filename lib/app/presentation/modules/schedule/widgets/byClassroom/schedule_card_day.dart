import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/extra_base_model.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

class ScheduleCardDay extends StatelessWidget {
  final Datum scheduleData;

  const ScheduleCardDay({
    required this.scheduleData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: responsive.wp(100),
          height: responsive.hp(7),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.only(
            right: responsive.wp(2),
            left: responsive.wp(2),
            top: responsive.hp(0.2),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 12,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        customXMargin(responsive.wp(24)),
                        Icon(
                          Icons.location_on,
                          color: Get.textTheme.headline2?.color,
                          size: responsive.ip(2),
                        ),
                        customXMargin(responsive.wp(1.5)),
                        Text(
                          '${scheduleData.classroom}',
                          style: Get.textTheme.headline4?.copyWith(
                            fontSize: responsive.ip(1.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: (HSLColor.fromColor(
                                        Get.theme.colorScheme.primary)
                                    .withLightness(0.76)
                                    .withSaturation(0.48))
                                .toColor(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(1.5),
                            vertical: responsive.hp(0.2),
                          ),
                          child: Text(
                            scheduleData.typeSchedule,
                            style: Get.textTheme.headline5?.copyWith(
                              fontSize: responsive.ip(1.3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        customXMargin(responsive.wp(3)),
                        // Icon(
                        //   UtplCustom.info,
                        //   color: Get.theme.colorScheme.onTertiaryContainer,
                        //   size: responsive.ip(2),
                        // ),
                        //customXMargin(responsive.wp(1)),
                      ],
                    ),
                    customYMargin(responsive.hp(0.7)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // Icon(
                              //   UtplCustom.education,
                              //   color: Get.textTheme.headline2?.color,
                              //   size: responsive.ip(2),
                              // ),
                              // customXMargin(responsive.wp(1)),
                              // Text(
                              //   'Componente:',
                              //   style: Get.textTheme.headline2?.copyWith(
                              //     fontSize: responsive.ip(1.6),
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                              customXMargin(responsive.wp(1)),
                              Expanded(
                                child: Text(
                                  scheduleData.title,
                                  maxLines: 1,
                                  style: Get.textTheme.headline4?.copyWith(
                                    fontSize: responsive.ip(1.6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //const Spacer(),
                    //const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    UtplCustom.right_small_arrow,
                    size: responsive.ip(2.5),
                    color: Get.theme.cardColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: responsive.hp(-1),
          left: responsive.wp(-1),
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Get.theme.shadowColor.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(2),
              vertical: responsive.hp(0.6),
            ),
            child: Text(
              '${scheduleData.beginClass} - ${scheduleData.endClass}',
              style: Get.textTheme.headline2?.copyWith(
                fontSize: responsive.ip(1.5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
    );
  }
}
