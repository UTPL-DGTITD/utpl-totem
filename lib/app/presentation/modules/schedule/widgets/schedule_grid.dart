import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/extra_base_model.dart';
import 'package:utpl_totem/app/data/models/generic_schedule_model.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/widgets/byClassroom/schedule_card_day.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/widgets/byUser/schedule_card.dart';

import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/responsive.dart';

class ScheduleGrid extends StatelessWidget {
  final GenericScheduleModel scheduleData;
  final ValueChanged<Datum>? onTap;
  final bool isLoading;
  final String groupBy;

  const ScheduleGrid({
    Key? key,
    required this.scheduleData,
    required this.isLoading,
    this.onTap,
    required this.groupBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive();

    return FadeInLeft(
      child: Container(
        color: Get.theme.cardColor,
        width: responsive.width,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: responsive.hp(1),
            //horizontal: responsive.wp(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Get.theme.cardColor,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        groupBy == 'subject' ? 'Materia:' : 'Día:',
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        scheduleData.title,
                        style: TextStyle(
                          fontSize: responsive.ip(2),
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              customYMargin(responsive.hp(2)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.wp(2),
                ),
                child: Wrap(
                    runSpacing: responsive.hp(2),
                    spacing: responsive.wp(2),
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      ...scheduleData.extras.first.data.map(
                        (schedule) {
                          return InkWell(
                            onTap: () {
                              if (onTap != null) {
                                onTap!(schedule);
                              }
                            },
                            child: groupBy == 'subject'
                                ? ScheduleCardSubject(
                                    scheduleData: schedule,
                                  )
                                : ScheduleCardDay(
                                    scheduleData: schedule,
                                  ),
                          );
                        },
                      ).toList(),
                    ]),
              ),
              groupBy == 'day'
                  ? customYMargin(responsive.hp(5))
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
