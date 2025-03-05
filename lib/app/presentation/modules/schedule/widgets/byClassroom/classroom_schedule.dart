import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/schedule/schedule_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/schedule/widgets/byClassroom/modal_dialog_buildings.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/schedule/widgets/schedule_grid.dart';
import 'package:utpl_totem_oficial/app/themes/custom_decoration.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';

class ClassroomSchedule extends StatelessWidget {
  final ScheduleController ctrl;
  const ClassroomSchedule({
    super.key,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: ctrl.responsive.hp(28),
              color: Get.theme.cardColor,
              padding: EdgeInsets.symmetric(horizontal: ctrl.responsive.wp(5)),
              child: Column(
                children: [
                  customYMargin(ctrl.responsive.hp(2)),
                  InkWell(
                    onTap: () => ModalDialogBuildings.showModalList(
                      context: context,
                      ctrl: ctrl,
                      items: ctrl.buildings,
                      scrollController: ctrl.contentBuildingScrollController,
                      title: 'Seleccione un edificio',
                      type: 'Building',
                      isLoading: ctrl.loadingBuildings.value,
                    ),
                    child: DropdownButtonFormField<String>(
                      iconSize: ctrl.responsive.ip(3),
                      isDense: false,
                      style: TextStyle(fontSize: ctrl.responsive.ip(2)),
                      isExpanded: true,
                      hint: Text(
                        ctrl.selectedBuilding.value,
                      ),
                      decoration: CustomDecoration.roundedDropdown(),
                      onChanged: (value) => ctrl.onBuildingChange(value),
                      items: const [],
                      //generateDropDownItems(ctrl.buildings),
                      value: ctrl.selectedBuilding.value.isNotEmpty
                          ? ctrl.selectedBuilding.value
                          : null,
                    ),
                  ),
                  customYMargin(ctrl.responsive.hp(1)),
                  InkWell(
                    onTap: () => ModalDialogBuildings.showModalList(
                      context: context,
                      ctrl: ctrl,
                      items: ctrl.classrooms,
                      scrollController: ctrl.contentClassroomsScrollController,
                      title: 'Seleccione un aula',
                      type: 'Claasroom',
                      isLoading: ctrl.loadingClassrooms.value,
                    ),
                    child: DropdownButtonFormField<String>(
                      iconSize: ctrl.responsive.ip(3),
                      style: TextStyle(fontSize: ctrl.responsive.ip(2)),
                      isDense: false,
                      isExpanded: true,
                      hint: Text(
                        ctrl.selectedClassroom.value,
                      ),
                      decoration: CustomDecoration.roundedDropdown(),
                      onChanged: (value) => ctrl.onClassroomChange(value),
                      items: const [],
                      //generateDropDownItems(ctrl.classrooms),
                      value: ctrl.selectedClassroom.value.isNotEmpty
                          ? ctrl.selectedClassroom.value
                          : null,
                    ),
                  ),
                  customYMargin(ctrl.responsive.hp(2)),
                  ctrl.classroomSchedule.isNotEmpty
                      ? Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: TabBar(
                                  controller: ctrl.tabControllerWeeks,
                                  tabs: ctrl.tabsWeek,
                                  labelStyle: TextStyle(
                                      fontSize: ctrl.responsive.ip(2)),
                                ),
                              ),
                              // customYMargin(ctrl.responsive.hp(1)),
                              Expanded(
                                child: Text(
                                  ctrl.selectedDay.value,
                                  style: TextStyle(
                                    fontSize: ctrl.responsive.ip(2),
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            ctrl.classroomSchedule.isNotEmpty
                ? Expanded(
                    child: Scrollbar(
                      controller: ctrl.contentResultsClassroomScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller:
                            ctrl.contentResultsClassroomScrollController,
                        child: SizedBox(
                          width: ctrl.responsive.wp(100),
                          height: ctrl.responsive.hp(49.7),
                          child: Column(
                            children: [
                              Expanded(
                                child: TabBarView(
                                  controller: ctrl.tabControllerWeeks,
                                  children: ctrl.classroomSchedule
                                      .map(
                                        (classroomSchedule) =>
                                            SingleChildScrollView(
                                          child: ScheduleGrid(
                                            ctrl: ctrl,
                                            groupBy: 'day',
                                            isLoading: false,
                                            scheduleData: classroomSchedule,
                                            onTap: (value) => ctrl.showModal(
                                                classroomSchedule,
                                                context,
                                                ctrl,
                                                value,
                                                true),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: ctrl.responsive.ip(2.5),
                      ),
                      customXMargin(ctrl.responsive.wp(2.5)),
                      Text(
                        "No se encontraron resultados",
                        style: TextStyle(
                          fontSize: ctrl.responsive.ip(2),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> generateDropDownItems(
      RxList<GenericListItemModel> items) {
    return [
      for (var i = 0; i < (items.length); i++) ...[
        DropdownMenuItem<String>(
          value: items[i].identifier,
          child: Text(
            items[i].title,
          ),
        )
      ],
    ];
  }
}
