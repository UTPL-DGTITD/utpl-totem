import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/academic_calendar/academic_calendar_controller.dart';
import 'package:utpl_totem/app/presentation/modules/academic_calendar/widgets/academic_calendar_item.dart';
import 'package:utpl_totem/app/presentation/modules/academic_calendar/widgets/modality_item.dart';
import 'package:utpl_totem/app/presentation/widgets/empty_results_widget.dart';
import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';

class AcademicCalendarPage extends GetView<AcademicCalendarController> {
  const AcademicCalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: const BackArrowButton(),
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<AcademicCalendarController>(
        init: AcademicCalendarController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          //authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
            child: ctrl.showSkeleton.isFalse
                ? SingleChildScrollView(
                    child: ctrl.hasModality.isTrue
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customYMargin(ctrl.responsive.hp(2)),
                              // Modalities
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ctrl.responsive.wp(3),
                                  vertical: ctrl.responsive.hp(1),
                                ),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Modalidad',
                                      style: Get.textTheme.titleLarge?.copyWith(
                                        fontSize: ctrl.responsive.ip(2),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    customYMargin(ctrl.responsive.hp(1)),
                                    ctrl.showLoadingModalities.isFalse
                                        ? Wrap(
                                            runSpacing: ctrl.responsive.hp(-1),
                                            spacing: ctrl.responsive.wp(2),
                                            direction: Axis.horizontal,
                                            children: [
                                              for (var i = 0;
                                                  i <
                                                      ctrl.modalitiesDetails
                                                          .length;
                                                  i++) ...[
                                                ModalityItem(
                                                  index: i,
                                                ),
                                              ],
                                            ],
                                          )
                                        : Container(
                                            alignment: Alignment.center,
                                            child:
                                                const CircularProgressIndicator(),
                                          ),

                                    // : const SkeletonList(length: 1),
                                  ],
                                ),
                              ),
                              customYMargin(ctrl.responsive.hp(1)),
                              // BUILDING CALENDARS

                              ctrl.showLoadingCalendars.isFalse
                                  ? ctrl.hasCalendar.isTrue
                                      ? ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              ctrl.activitiesDetails.length,
                                          itemBuilder: (context, int index) {
                                            return AcademicCalendarItem(
                                              index: index,
                                            );
                                          },
                                        )
                                      : Center(
                                          child: EmptyResultsWidget(
                                            assetPath:
                                                'assets/images/story-set/story-set-login.png',
                                            description:
                                                "No existen calendarios académicos para la modalidad seleccionada.",
                                            btnText: "Volver",
                                            onTap: () => Get.back(),
                                          ),
                                        )
                                  : const SkeletonList(length: 10),
                            ],
                          )
                        : Center(
                            child: EmptyResultsWidget(
                              assetPath:
                                  'assets/images/story-set/story-set-login.png',
                              description:
                                  "No existen calendarios académicos actualmente",
                              btnText: "Volver",
                              onTap: () => Get.back(),
                            ),
                          ),
                  )
                : const SkeletonList(length: 3),
          );
        },
      ),
    );
  }
}
