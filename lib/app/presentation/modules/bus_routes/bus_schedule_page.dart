import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:utpl_totem_oficial/app/presentation/modules/bus_routes/bus_schedule_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/footer_utpl.dart';

class BusSchedulePage extends GetView<BusScheduleController> {
  const BusSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusScheduleController>(
      init: BusScheduleController(
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
      initState: (_) {},
      builder: (ctrl) {
        return Scaffold(
          floatingActionButton: const FloatBackButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: AppBar(
            toolbarHeight: ctrl.responsive.hp(10),
            centerTitle: true,
            leading: const SizedBox(),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => ctrl.previousDay(),
                  child: Icon(
                    Icons.arrow_left,
                    size: ctrl.responsive.ip(5),
                  ),
                ),
                Text(
                  ctrl.getDayName(weekDay: ctrl.currentDate.value.weekday),
                  style: TextStyle(
                    fontSize: ctrl.responsive.ip(2.8),
                  ),
                ),
                TextButton(
                  onPressed: () => ctrl.nextDay(),
                  child: Icon(
                    Icons.arrow_right,
                    size: ctrl.responsive.ip(5),
                  ),
                ),
              ],
            ),
            actions: const [SizedBox.square(dimension: 50)],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: ctrl.responsive.hp(83),
                  padding:
                      EdgeInsets.symmetric(horizontal: ctrl.responsive.hp(0.5)),
                  child: CalendarDayView.overflow(
                    events: ctrl.busRoutes,
                    dividerColor: Colors.black,
                    renderRowAsListView: true,
                    currentDate: DateTime.now(),
                    timeGap: 30,
                    showCurrentTimeLine: true,
                    timeTextStyle: TextStyle(
                      fontSize: ctrl.responsive.ip(2),
                      fontWeight: FontWeight.w500,
                    ),
                    timeTitleColumnWidth: ctrl.responsive.wp(13),
                    heightPerMin: ctrl.responsive.hp(0.32),
                    showMoreOnRowButton: true,
                    startOfDay: const TimeOfDay(hour: 6, minute: 00),
                    endOfDay: const TimeOfDay(hour: 22, minute: 00),
                    overflowItemBuilder:
                        (context, constraints, itemIndex, event) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        key: ValueKey(event.hashCode),
                        onTap: () {
                          ctrl.loadRouteShedule(
                            context,
                            event.value.id,
                            ctrl,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 3, left: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          key: ValueKey(event.hashCode),
                          width: Get.width / 3 - 6,
                          height: constraints.maxHeight,
                          decoration: BoxDecoration(
                            color: itemIndex % 2 == 0
                                ? Get.theme.colorScheme.primaryContainer
                                : Get.theme.colorScheme.secondaryContainer,
                            border: Border.all(
                                color: Get.theme.colorScheme.tertiaryContainer,
                                width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Línea ${event.value.line}\n',
                                children: [
                                  TextSpan(
                                    text: event.value.name,
                                    style: TextStyle(
                                      color: Get.theme.colorScheme.onSecondary,
                                      fontWeight: FontWeight.normal,
                                      fontSize: ctrl.responsive.ip(1.8),
                                    ),
                                  ),
                                ],
                                style: TextStyle(
                                  color: Get.theme.colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ctrl.responsive.ip(1.9),
                                ),
                              ),
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const FooterUTPL(),
              ],
            ),
          ),
        );
      },
    );
  }
}
