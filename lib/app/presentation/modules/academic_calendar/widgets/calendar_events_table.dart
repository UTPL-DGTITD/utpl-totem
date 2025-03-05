import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/academic_calendar/academic_calendar_controller.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';

class CalendarEventsTable extends StatelessWidget {
  final int index;

  const CalendarEventsTable({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AcademicCalendarController>();

    return Container(
      color: Get.theme.cardColor,
      width: double.infinity,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              color: Get.theme.cardColor,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                // horizontal: ctrl.responsive.wp(0),
                vertical: ctrl.responsive.hp(2),
              ),
              child: Column(
                children: generateItems(ctrl, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _generateRowColor(int i) {
    return i % 2 == 0
        ? Get.theme.colorScheme.secondaryContainer.withOpacity(0.5)
        : Colors.transparent;
  }

  List<Widget> generateItems(AcademicCalendarController ctrl, int index) {
    List<Widget> items = [];
    String temporalCategory = '';
    var item = ctrl.activitiesDetails[index];

    for (var i = 0; i < item.length; i++) {
      for (var j = 0; j < item.elementAt(i).length; j++) {
        if (temporalCategory != item.elementAt(i).elementAt(j).title) {
          items.add(Container(
            color: Get.theme.colorScheme.primary,
            child: ListTile(
              title: Text(
                item.elementAt(i).elementAt(j).title,
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontSize: ctrl.responsive.ip(1.7),
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ));
        }
        temporalCategory = item.elementAt(i).elementAt(j).title;
        items.add(Container(
          padding: EdgeInsets.symmetric(vertical: ctrl.responsive.hp(0.5)),
          color: _generateRowColor(j),
          child: ListTile(
            title: Text(
              item.elementAt(i).elementAt(j).description,
              style: Get.textTheme.titleLarge?.copyWith(
                fontSize: ctrl.responsive.ip(1.5),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customYMargin(ctrl.responsive.hp(0.5)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      UtplCustom.calendar,
                      size: ctrl.responsive.ip(1.8),
                      color: Get.theme.iconTheme.color,
                    ),
                    Text(
                      ' ${DateFormat('yyyy-MM-dd').format(item.elementAt(i).elementAt(j).startDate!)} hasta ${DateFormat('yyyy-MM-dd').format(item.elementAt(i).elementAt(j).endDate!)}',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: ctrl.responsive.ip(1.5),
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // trailing: Column(
            //   children: const [
            //     Icon(
            //       Icons.add,
            //       color: Colors.green,
            //     ),
            //   ],
            // ),
          ),
        ));
      }
    }
    return items;
  }
}
