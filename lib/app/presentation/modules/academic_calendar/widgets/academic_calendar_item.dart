import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/academic_calendar/academic_calendar_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/academic_calendar/widgets/calendar_events_table.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';

class AcademicCalendarItem extends StatelessWidget {
  final int index;

  const AcademicCalendarItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AcademicCalendarController>();
    var responsive = Responsive();
    var item = ctrl.activitiesDetails[index];

    return Container(
      color: Get.theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => ExpansionPanelList(
              expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0),
              elevation: 0,
              animationDuration: const Duration(milliseconds: 150),
              children: [
                ExpansionPanel(
                    backgroundColor: Colors.transparent,
                    canTapOnHeader: true,
                    isExpanded: ctrl.isOpen[index].value,
                    headerBuilder: (context, isExpanded) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: responsive.wp(5),
                          left: responsive.wp(5),
                          top: responsive.wp(4),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            ctrl.getProgramCalendar(
                                item.first.first.academicProgram),
                            style: Get.textTheme.titleLarge?.copyWith(
                              fontSize: responsive.ip(1.75),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                    body: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            //horizontal: responsive.wp(3),
                            //vertical: responsive.hp(2),
                            ),
                        child: SizedBox(
                          width: double.infinity,
                          child: CalendarEventsTable(
                            index: index,
                          ),
                        ),
                      ),
                    ))
              ],
              expansionCallback: (i, isExpanded) =>
                  ctrl.isOpen[index].value = !isExpanded,
            ),
          ),
        ],
      ),
    );
  }
}
