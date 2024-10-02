import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/schedule_controller.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/widgets/schedule_grid.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';

class ScheduleResults extends StatelessWidget {
  final ScheduleController ctrl;
  const ScheduleResults({
    super.key,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: Get.theme.cardColor,
        padding: EdgeInsets.only(
          top: ctrl.responsive.hp(1),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                right: ctrl.responsive.wp(4),
                left: ctrl.responsive.wp(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Usuario UTPL: ${ctrl.inputController.value.text}\nTotal materias: ${ctrl.userSchedule.length}',
                      style: TextStyle(
                        fontSize: ctrl.responsive.ip(2.2),
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => ctrl.newQuery(),
                      child: Column(
                        children: [
                          Icon(
                            Icons.replay_outlined,
                            size: ctrl.responsive.ip(3),
                            color: Get.theme.colorScheme.primary,
                          ),
                          Text(
                            'Volver a buscar',
                            style: TextStyle(
                              fontSize: ctrl.responsive.ip(1.6),
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => _showPrintOptions(context, ctrl),
                      child: Column(
                        children: [
                          Icon(
                            Icons.print,
                            size: ctrl.responsive.ip(3),
                            color: Get.theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            customYMargin(ctrl.responsive.hp(1)),
            Divider(
              color: Get.theme.colorScheme.primary,
              height: ctrl.responsive.hp(0.5),
              thickness: ctrl.responsive.hp(0.5),
            ),
            customYMargin(ctrl.responsive.hp(1)),
            ctrl.userSchedule.isNotEmpty
                ? Expanded(
                    child: Scrollbar(
                      controller: ctrl.contentResultsUserScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: ctrl.contentResultsUserScrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: generateSchedule(ctrl, context),
                        ),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: ctrl.responsive.ip(2.5),
                      ),
                      customXMargin(ctrl.responsive.wp(2)),
                      const Text(
                        "No se encontraron resultados",
                      ),
                    ],
                  ),
            //customYMargin(ctrl.responsive.hp(2)),
          ],
        ),
      ),
    );
  }

  // Función para mostrar el modal de selección de impresión con RadioListTile
  void _showPrintOptions(BuildContext context, ScheduleController ctrl) {
    String selectedOption = 'Día'; // Valor por defecto

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Seleccione tipo de agrupación',
                style: TextStyle(
                  fontSize: ctrl.responsive.ip(2.3),
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<String>(
                    activeColor: Get.theme.colorScheme.primary,
                    title: Text(
                      'Por Día',
                      style: TextStyle(
                        fontSize: ctrl.responsive.ip(2.2),
                        fontWeight: FontWeight.normal,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                    value: 'Día',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    activeColor: Get.theme.colorScheme.primary,
                    title: Text(
                      'Por Componente',
                      style: TextStyle(
                        fontSize: ctrl.responsive.ip(2.2),
                        fontWeight: FontWeight.normal,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                    value: 'Componente',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ctrl.responsive.wp(10),
                    vertical: ctrl.responsive.hp(1),
                  ),
                  width: double.maxFinite,
                  child: MaterialButton(
                    padding: EdgeInsets.symmetric(
                      vertical: ctrl.responsive.hp(3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    color: Get.theme.colorScheme.tertiary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Confirmar',
                          style: Get.textTheme.headlineMedium?.copyWith(
                            fontSize: ctrl.responsive.ip(2),
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (selectedOption == 'Día') {
                        ctrl.printScheduleThermalByDay(context);
                      } else {
                        ctrl.printScheduleThermal(context);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> generateSchedule(ScheduleController ctrl, BuildContext context) {
    List<Widget> items = [];
    for (var i = 0; i < ctrl.userSchedule.length; i++) {
      items.add(
        ScheduleGrid(
          ctrl: ctrl,
          groupBy: 'subject',
          isLoading: false,
          scheduleData: ctrl.userSchedule[i],
          onTap: (value) => ctrl.showModal(
            ctrl.userSchedule[i],
            context,
            ctrl,
            value,
            false,
          ),
        ),
      );
      if (i == ctrl.userSchedule.length - 1) {
        items.add(customYMargin(ctrl.responsive.hp(4)));
      }
    }
    return items;
  }
}
