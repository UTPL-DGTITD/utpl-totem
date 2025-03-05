import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/extra_base_model.dart';
import 'package:utpl_totem_oficial/app/data/models/generic_schedule_model.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/schedule/schedule_controller.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';

class ModalDialogSchedule {
  static Future<dynamic> alertSchedule(
      BuildContext context,
      GenericScheduleModel item,
      ScheduleController ctrl,
      Datum datum,
      bool showReference) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          Responsive responsive = Responsive();
          return AlertDialog(
            insetPadding: EdgeInsets.only(
              top: responsive.hp(8),
              bottom: responsive.hp(15),
              right: ctrl.responsive.wp(10),
              left: ctrl.responsive.wp(10),
            ),
            backgroundColor: Get.theme.canvasColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.wp(2),
              vertical: responsive.hp(1),
            ),
            title: SizedBox(
              width: responsive.wp(100),
              child: Text(
                item.title,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: responsive.ip(2.5),
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: SizedBox(
              height: responsive.hp(50),
              child: Column(
                children: [
                  showReference
                      ? Text(
                          ctrl.getReferenceClassroom(
                              ctrl.selectedIdClassroom.value, datum),
                          style: TextStyle(
                            fontSize: ctrl.responsive.ip(2.2),
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : datum.place == ''
                          ? const SizedBox()
                          : Text(
                              '${datum.place} - ${datum.classroom}',
                              style: TextStyle(
                                fontSize: ctrl.responsive.ip(2.2),
                                color: Get.theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                  customYMargin(ctrl.responsive.hp(1)),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: ctrl.contentScrollController,
                      child: SingleChildScrollView(
                        controller: ctrl.contentScrollController,
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(2),
                            vertical: responsive.hp(2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InfoSchedule(
                                title: 'Día:',
                                description: datum.day,
                              ),
                              InfoSchedule(
                                title: 'Tipo de horario:',
                                description: datum.typeSchedule,
                              ),
                              InfoSchedule(
                                title: 'Hora inicio:',
                                description: datum.beginClass,
                              ),
                              InfoSchedule(
                                title: 'Hora fin:',
                                description: datum.endClass,
                              ),
                              InfoSchedule(
                                title: 'Paralelo:',
                                description: datum.title,
                              ),
                              InfoSchedule(
                                title: 'Edificio:',
                                description: datum.place,
                              ),
                              InfoSchedule(
                                title: 'Aula:',
                                description: datum.classroom,
                              ),
                              InfoSchedule(
                                title: 'Docente:',
                                description: ctrl.getStringByIdentifier(
                                        datum.relation, 'Docente') ??
                                    '-',
                              ),
                              InfoSchedule(
                                title: 'Modalidad:',
                                description: ctrl.getStringByIdentifier(
                                        datum.relation, 'Modalidad') ??
                                    '-',
                              ),
                              InfoSchedule(
                                title: 'Periódo Académico:',
                                description: ctrl.getStringByIdentifier(
                                        datum.relation, 'Periodo Academico') ??
                                    '-',
                              ),
                              InfoSchedule(
                                title: 'Nivel Acádemico:',
                                description: ctrl.getStringByIdentifier(
                                        datum.relation, 'Nivel Acádemico') ??
                                    '-',
                              ),
                              // InfoSchedule(
                              //   title: 'Enlace Tutoría:',
                              //   description: ctrl.getStringByIdentifier(
                              //           datum.relation, 'EnlaceTutoria') ??
                              //       '-',
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: responsive.wp(35),
                    padding: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(responsive.ip(2)),
                            ),
                          ),
                          backgroundColor: WidgetStateColor.resolveWith(
                              (states) => Get.theme.colorScheme.error)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: responsive.hp(1)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Icon(
                                Icons.close,
                                size: responsive.ip(2.5),
                                color: Get.theme.cardColor,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Cerrar',
                                style: Get.textTheme.titleLarge?.copyWith(
                                  fontSize: responsive.ip(2),
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.colorScheme.onError,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  customYMargin(responsive.hp(1)),
                ],
              )
            ],
          );
        });
  }
}

class InfoSchedule extends StatelessWidget {
  final String title;
  final String description;
  const InfoSchedule({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: responsive.ip(1.9),
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            //const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 1,
              child: Text(
                description != '' ? description : ' -- ',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: responsive.ip(1.9),
                  fontWeight: FontWeight.normal,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
