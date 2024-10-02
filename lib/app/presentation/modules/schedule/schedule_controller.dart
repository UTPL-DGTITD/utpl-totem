import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utpl_totem/app/data/models/extra_base_model.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/models/generic_schedule_model.dart';
import 'package:utpl_totem/app/data/models/related_base_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/widgets/modal_dialog_schedule.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';
import 'package:utpl_totem/app/utils/validators/validators_forms.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class ScheduleController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValidatorsForm validatorsForm = ValidatorsForm();
  Rx<TextEditingController> inputController =
      TextEditingController(text: '').obs;
  final username = ''.obs;
  RxList<GenericScheduleModel> userSchedule = <GenericScheduleModel>[].obs;
  RxList<GenericListItemModel> buildings = <GenericListItemModel>[].obs;
  RxList<GenericListItemModel> classrooms = <GenericListItemModel>[].obs;
  RxList<GenericScheduleModel> classroomSchedule = <GenericScheduleModel>[].obs;
  final title = 'Horarios'.obs;
  final selectedIdBuilding = ''.obs;
  final selectedBuilding = ''.obs;
  final selectedIdClassroom = ''.obs;
  final selectedClassroom = ''.obs;
  final selectedDay = ''.obs;

  RegExp regExp = RegExp(r''); //RegExp(r'^[a-zA-Z0-9.\b\u{0008}]+$');

  RxBool showSkeleton = false.obs;
  RxBool showSchedule = false.obs;
  RxBool showBuildings = false.obs;
  RxBool showClassrooms = false.obs;
  RxBool showClassroomSchedule = false.obs;
  ScrollController contentScrollController = ScrollController();
  // FOR BUILDINGS
  ScrollController contentBuildingScrollController = ScrollController();
  final pageBuildings = 1.obs;
  RxBool loadingBuildings = false.obs;
  // FOR CLASSROOMS
  ScrollController contentClassroomsScrollController = ScrollController();
  final pageClassrooms = 1.obs;
  RxBool loadingClassrooms = false.obs;
  ScrollController contentResultsUserScrollController = ScrollController();
  ScrollController contentResultsClassroomScrollController = ScrollController();

  late TabController tabController;
  late TabController tabControllerWeeks;

  List<Tab> tabs = [];
  List<Tab> tabsWeek = [];

  ScheduleController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
  });

  @override
  void onInit() {
    _initConfig();
    tabs = [
      Tab(
        iconMargin: const EdgeInsets.symmetric(),
        text: 'Por usuario',
        height: responsive.hp(7),
        icon: Icon(
          Icons.person,
          size: responsive.ip(3),
        ),
      ),
      Tab(
        iconMargin: const EdgeInsets.symmetric(),
        text: 'Por aula',
        height: responsive.hp(7),
        icon: Icon(
          Icons.location_on,
          size: responsive.ip(3),
        ),
      ),
    ];
    tabController = TabController(length: tabs.length, vsync: this);

    super.onInit();
  }

  void _initConfig() async {
    try {
      await loadBuildings();
      addListenerBuildings();
      addListenerClassrooms();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[schedule_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void onChangeUsername(String value) async {
    ToolsHelper.logger.v(value);
    username.value = value;
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void validateUsername(BuildContext context, ScheduleController ctrl) async {
    if (isValidForm()) {
      ToolsHelper.logger.v('VALIDO');
      try {
        toastService.presentLoading();
        var result = await apiRepository.getSubjectSchedule(
          body: {
            "user": inputController.value.text,
          },
        );
        switch (result.status) {
          case 200:
            toastService.hideLoading();
            userSchedule.assignAll(genericScheduleModelFromList(result.data));
            ToolsHelper.logger.v(userSchedule.toJson());
            showSchedule.value = true;
            //ModalDialogSchedule.alertSchedule(context, userSchedule, ctrl);

            break;
          case 404:
            toastService.presentWarningToast(
              text: "No existe información para el usuario ingresado",
            );
            toastService.hideLoading();
            break;

          default:
        }
      } on TimeoutException {
        toastService.hideLoading();
        toastService.presentWarningToast(
          text: "Tiempo de espera agotado",
        );
      } on SocketException {
        toastService.hideLoading();

        toastService.presentWarningToast(
          text: "Error de conexión",
        );
      } catch (error, stack) {
        toastService.hideLoading();

        ToolsHelper.logger.e(
          '[schedule_controller] (validateUsername)',
          error,
          stack,
        );
        toastService.presentErrorToast(
          text: 'Error nuestro, intenta más tarde',
        );
      }
    }
  }

  void clearInput() {
    inputController.value.text = '';
  }

  onKeyPressed(VirtualKeyboardKey key) {
    //ToolsHelper.logger.v(key.keyType);
    ToolsHelper.logger.v(key.action);
    if (regExp.hasMatch(key.text ?? '')) {
      // Solo se permite insertar números y letras
      inputController.value.text += key.text ?? '';
    }
    if (key.action == VirtualKeyboardKeyAction.Backspace) {
      if (inputController.value.text != '') {
        inputController.value.text = inputController.value.text
            .substring(0, inputController.value.text.length - 1);
      }
    }
  }

  void newQuery() {
    showSchedule.value = false;
    clearInput();
  }

  void showModal(GenericScheduleModel item, BuildContext context,
      ScheduleController ctrl, Datum datum, bool reference) {
    ToolsHelper.logger.v('El id es: ${datum.identifier}');
    ModalDialogSchedule.alertSchedule(context, item, ctrl, datum, reference);
  }

  String? getStringByIdentifier(
      List<RelatedBaseModel>? relation, String identifier) {
    if (relation == null || relation.isEmpty) {
      return null;
    }

    var link =
        relation.firstWhereOrNull((element) => element.type == identifier);
    return (link?.name != null && link!.name.isNotEmpty) ? link.name : null;
  }

  Future<void> loadBuildings() async {
    try {
      toastService.presentLoading();
      var result = await apiRepository.getBuildings(
        page: pageBuildings.value,
      );
      switch (result.status) {
        case 200:
          toastService.hideLoading();
          buildings.assignAll(genericListItemModelFromList(result.data));
          selectedIdBuilding.value = buildings.first.identifier;
          selectedBuilding.value = buildings.first.title;
          await loadClassrooms(selectedIdBuilding.value);
          showBuildings.value = true;
          break;
        case 404:
          toastService.presentWarningToast(
            text: "No existe información",
          );
          toastService.hideLoading();
          break;

        default:
      }
    } on TimeoutException {
      toastService.hideLoading();
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.hideLoading();

      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      toastService.hideLoading();

      ToolsHelper.logger.e(
        '[schedule_controller] (loadBuildings)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  Future<void> loadClassrooms(String buildingCode) async {
    try {
      toastService.presentLoading();
      var result = await apiRepository.getClassrooms(
        buildingCode: buildingCode,
        page: pageClassrooms.value,
      );
      switch (result.status) {
        case 200:
          toastService.hideLoading();
          classrooms.assignAll(genericListItemModelFromList(result.data));
          selectedIdClassroom.value = classrooms.first.identifier;
          selectedClassroom.value = classrooms.first.title;
          await loadClassroomSchedule(selectedIdClassroom.value);
          showClassrooms.value = true;
          break;
        case 404:
          toastService.presentWarningToast(
            text: "No existe información",
          );
          toastService.hideLoading();
          break;

        default:
      }
    } on TimeoutException {
      toastService.hideLoading();
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.hideLoading();

      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      toastService.hideLoading();

      ToolsHelper.logger.e(
        '[schedule_controller] (loadClassrooms)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void onBuildingChange(String? value) {
    loadClassrooms(value ?? '');
  }

  Future<void> loadClassroomSchedule(String classroomCode) async {
    try {
      toastService.presentLoading();
      var result = await apiRepository.getClassroomSchedule(
        body: {
          "course": classroomCode,
        },
      );
      switch (result.status) {
        case 200:
          toastService.hideLoading();
          classroomSchedule
              .assignAll(genericScheduleModelFromList(result.data));

          tabsWeek = classroomSchedule
              .map(
                (classroomSchedule) => Tab(
                  iconMargin: const EdgeInsets.symmetric(),
                  text: classroomSchedule.title.substring(0, 1),
                  height: responsive.hp(7),
                ),
              )
              .toList();

          tabControllerWeeks =
              TabController(length: classroomSchedule.length, vsync: this);
          tabControllerWeeks.addListener(handleTabSelection);
          selectedDay.value = classroomSchedule.first.title;

          showClassroomSchedule.value = true;

          break;
        case 404:
          classroomSchedule.value = [];
          toastService.presentWarningToast(
            text: "No existe información",
          );
          toastService.hideLoading();
          break;

        default:
      }
    } on TimeoutException {
      toastService.hideLoading();
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.hideLoading();

      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      toastService.hideLoading();

      ToolsHelper.logger.e(
        '[schedule_controller] (loadClassroomSchedule)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void onClassroomChange(String? value) {
    loadClassroomSchedule(value ?? '');
  }

  void onSelectBuilding(String type, GenericListItemModel item) {
    if (type == 'Building') {
      selectedBuilding.value = item.title;
      selectedIdBuilding.value = item.identifier;
      Get.back();
      pageClassrooms.value = 1;
      loadClassrooms(selectedIdBuilding.value);
    } else if (type == 'Claasroom') {
      selectedClassroom.value = item.title;
      selectedIdClassroom.value = item.identifier;
      loadClassroomSchedule(selectedIdClassroom.value);
      Get.back();
    }
  }

  void addListenerBuildings() {
    contentBuildingScrollController.addListener(() {
      if (contentBuildingScrollController.position.pixels >=
          (contentBuildingScrollController.position.maxScrollExtent)) {
        loadMoreBuildings();
      }
    });
  }

  void addListenerClassrooms() {
    contentClassroomsScrollController.addListener(() {
      if (contentClassroomsScrollController.position.pixels >=
          (contentClassroomsScrollController.position.maxScrollExtent)) {
        loadMoreClassrooms();
      }
    });
  }

  void loadMoreBuildings() async {
    loadingBuildings.value = true;
    pageBuildings.value++;
    try {
      var result = await apiRepository.getBuildings(page: pageBuildings.value);
      switch (result.status) {
        case 200:
          buildings.addAll(genericListItemModelFromList(result.data));
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      loadingBuildings.value = false;
    } on TimeoutException {
      loadingBuildings.value = false;
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      loadingBuildings.value = false;
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      loadingBuildings.value = false;
      ToolsHelper.logger.e(
        '[schedule_controller] (loadMoreBuildings)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void loadMoreClassrooms() async {
    loadingClassrooms.value = true;
    pageClassrooms.value++;
    try {
      var result = await apiRepository.getClassrooms(
        buildingCode: selectedIdBuilding.value,
        page: pageClassrooms.value,
      );
      switch (result.status) {
        case 200:
          classrooms.addAll(genericListItemModelFromList(result.data));
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      loadingClassrooms.value = false;
    } on TimeoutException {
      loadingClassrooms.value = false;
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      loadingClassrooms.value = false;
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      loadingClassrooms.value = false;
      ToolsHelper.logger.e(
        '[schedule_controller] (loadMoreClassrooms)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void handleTabSelection() {
    selectedDay.value = classroomSchedule[tabControllerWeeks.index].title;
  }

  String getReferenceClassroom(String identifier, Datum datum) {
    String building = '';
    String floor = '';
    String classroom = '';
    if (isNumber(identifier[0])) {
      building = identifier.substring(0, 2);
      floor = identifier[identifier.length - 2];
      classroom = identifier[identifier.length - 1];
      return 'Edificio ${building.toString()} - Piso ${floor.toString()} - Aula ${classroom.toString()}';
    } else {
      return '${datum.place} - ${datum.classroom}';
    }
  }

  bool isNumber(String caracter) {
    // Verifica si el carácter es un número comparando su valor Unicode.
    return caracter.codeUnitAt(0) >= 48 && caracter.codeUnitAt(0) <= 57;
  }

  void printScheduleThermalByDay(BuildContext context) async {
    try {
      final port = SerialPort('COM4');

      if (!port.openReadWrite()) {
        throw 'Error al abrir el puerto COM4: ${SerialPort.lastError}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iniciando la impresión...')),
      );

      // Generar el texto del recibo
      StringBuffer buffer = StringBuffer();

      buffer.writeln(centerText('\x1B\x45\x01HORARIO DE CLASES\x1B\x45\x00'));

      // Datos del estudiante
      buffer.writeln(
          '\x1B\x45\x01UTPLiD:\x1B\x45\x00 ${inputController.value.text}');

      buffer.writeln(generateLine('='));

      // Agrupar eventos por día
      Map<String, List> groupedByDay = groupEventsByDay(userSchedule);

      // Recorrer los días de la semana
      for (var day in groupedByDay.keys) {
        buffer.writeln(centerText('\x1B\x45\x01$day\x1B\x45\x00'));
        buffer.writeln(generateLine('-'));

        // Recorrer los eventos del día
        for (var event in groupedByDay[day]!) {
          buffer.write('\x1B\x45\x01- ${event['typeSchedule']}:\x1B\x45\x00 ');
          buffer.writeln(
              '(${event['beginClass']}-${event['endClass']}) ${event['subject']} (${event['period']})');

          if (event['place'].isEmpty && event['classroom'].isEmpty) {
            buffer.writeln('EN LINEA');
          } else {
            buffer.writeln(
                '${event['place'].isNotEmpty ? event['place'] : ""}${event['place'].isNotEmpty && event['classroom'].isNotEmpty ? ": " : ""}${event['classroom'].isNotEmpty ? event['classroom'] : ""}');
          }
        }

        buffer.writeln(generateLine('-'));
      }

      // Fecha y hora
      buffer.writeln(
          '\x1B\x45\x01Fecha:\x1B\x45\x00 ${DateFormat('yyyy-MM-dd').format(DateTime.now())} - \x1B\x45\x01Hora:\x1B\x45\x00 ${DateFormat('HH:mm:ss').format(DateTime.now())}');
      buffer.writeln(
        centerText(
            '\x1B\x45\x01Powered by DGTI & TD\x1B\x45\x00\x0A\x0A\x0A\x0A'),
      );

      // Guardar el contenido del buffer en una variable para impresión en consola
      String bufferContent = buffer.toString();

      // Imprimir en consola
      ToolsHelper.logger.v(bufferContent);
      //print(bufferContent);

      // Enviar el contenido del buffer a la impresora
      final Uint8List data = Uint8List.fromList(bufferContent.codeUnits);
      const int fragmentSize = 512;
      for (int i = 0; i < data.length; i += fragmentSize) {
        int end =
            (i + fragmentSize < data.length) ? i + fragmentSize : data.length;
        port.write(data.sublist(i, end));
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // CORTAR PAPEL
      final Uint8List cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
      port.write(cutCommand);

      // Cerrar el puerto
      port.close();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impresión completada con éxito')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error durante la impresión: $e')),
      );
    }
  }

  void printScheduleThermal(BuildContext context) async {
    try {
      final port = SerialPort('COM4');

      if (!port.openReadWrite()) {
        throw 'Error al abrir el puerto COM4: ${SerialPort.lastError}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iniciando la impresión...')),
      );

      // Generar el texto del recibo
      StringBuffer buffer = StringBuffer();

      buffer.writeln(centerText('\x1B\x45\x01HORARIO DE CLASES\x1B\x45\x00'));

      // Datos del estudiante
      buffer.writeln(
          '\x1B\x45\x01UTPLiD:\x1B\x45\x00 ${inputController.value.text}');
      buffer.writeln(generateLine('='));

      // Recorrer cada asignatura
      for (var subject in userSchedule) {
        // Título de la asignatura en negrita
        buffer.writeln(
          centerText('\x1B\x45\x01${subject.title}\x1B\x45\x00'),
        );
        buffer.writeln(
          centerText(getStringByIdentifier(
                  subject.extras[0].data[0].relation, 'Periodo Academico') ??
              ''),
        );

        // Horarios
        for (var schedule in subject.extras[0].data) {
          buffer.write(
              '\x1B\x45\x01- ${schedule.typeSchedule}:\x1B\x45\x00 '); // Tipo de horario
          buffer.writeln(
              '${schedule.day} (${schedule.beginClass}-${schedule.endClass})'); // Día y horas

          if (schedule.place.isEmpty && schedule.classroom.isEmpty) {
            buffer.writeln('EN LINEA');
          } else {
            buffer.writeln(
                '${schedule.place.isNotEmpty ? schedule.place : ""}${schedule.place.isNotEmpty && schedule.classroom.isNotEmpty ? ": " : ""}${schedule.classroom.isNotEmpty ? schedule.classroom : ""}');
          }
        }
        buffer.writeln(generateLine('-'));
      }

      // Fecha y hora
      buffer.writeln(
          '\x1B\x45\x01Fecha:\x1B\x45\x00 ${DateFormat('yyyy-MM-dd').format(DateTime.now())} - \x1B\x45\x01Hora:\x1B\x45\x00 ${DateFormat('HH:mm:ss').format(DateTime.now())}');
      buffer.writeln(
        centerText(
            '\x1B\x45\x01Powered by DGTI & TD\x1B\x45\x00\x0A\x0A\x0A\x0A'),
      );

      final Uint8List data = Uint8List.fromList(buffer.toString().codeUnits);
      const int fragmentSize = 512;
      for (int i = 0; i < data.length; i += fragmentSize) {
        int end =
            (i + fragmentSize < data.length) ? i + fragmentSize : data.length;
        port.write(data.sublist(i, end));
        await Future.delayed(const Duration(milliseconds: 50));
      }

      // CORTAR PAPEL
      final Uint8List cutCommand = Uint8List.fromList([0x1D, 0x56, 0x00]);
      port.write(cutCommand);

      // Cerrar el puerto
      port.close();

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impresión completada con éxito')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error durante la impresión: $e')),
      );
    }
  }

  Map<String, List> groupEventsByDay(List<GenericScheduleModel> userSchedule) {
    // Define el orden de los días de la semana
    final List<String> weekDaysOrder = [
      'LUNES',
      'MARTES',
      'MIERCOLES',
      'JUEVES',
      'VIERNES',
      'SABADO',
      'DOMINGO'
    ];

    Map<String, List> groupedByDay = {};

    // Agrupar los eventos por día
    for (var subject in userSchedule) {
      for (var extra in subject.extras) {
        for (var schedule in extra.data) {
          // Si el día no está en el mapa, se inicializa con una lista vacía
          if (!groupedByDay.containsKey(schedule.day)) {
            groupedByDay[schedule.day] = [];
          }
          // Añadir el evento a la lista correspondiente al día
          groupedByDay[schedule.day]!.add({
            'subject': subject.title,
            'typeSchedule': schedule.typeSchedule,
            'beginClass': schedule.beginClass,
            'endClass': schedule.endClass,
            'place': schedule.place,
            'classroom': schedule.classroom,
            'period':
                getStringByIdentifier(schedule.relation, 'Periodo Academico') ??
                    ''
          });
        }
      }
    }

    // Ordenar el mapa según el orden de los días de la semana
    Map<String, List> sortedGroupedByDay = Map.fromEntries(
      weekDaysOrder.where((day) => groupedByDay.containsKey(day)).map(
            (day) => MapEntry(day, groupedByDay[day]!),
          ),
    );

    return sortedGroupedByDay;
  }

  Map<String, Map<String, List>> groupEventsByDay2(
      List<GenericScheduleModel> userSchedule) {
    // Define el orden de los días de la semana
    final List<String> weekDaysOrder = [
      'LUNES',
      'MARTES',
      'MIERCOLES',
      'JUEVES',
      'VIERNES',
      'SABADO',
      'DOMINGO'
    ];
    Map<String, Map<String, List>> groupedByDayAndSubject = {};

    for (var subject in userSchedule) {
      for (var extra in subject.extras) {
        for (var schedule in extra.data) {
          String subjectKey =
              '${subject.title} - ${getStringByIdentifier(schedule.relation, 'Periodo Academico') ?? ''}';
          if (!groupedByDayAndSubject.containsKey(schedule.day)) {
            groupedByDayAndSubject[schedule.day] = {};
          }
          if (!groupedByDayAndSubject[schedule.day]!.containsKey(subjectKey)) {
            groupedByDayAndSubject[schedule.day]![subjectKey] = [];
          }
          groupedByDayAndSubject[schedule.day]![subjectKey]!.add({
            'subject': subject.title,
            'typeSchedule': schedule.typeSchedule,
            'beginClass': schedule.beginClass,
            'endClass': schedule.endClass,
            'place': schedule.place,
            'classroom': schedule.classroom,
            'period':
                getStringByIdentifier(schedule.relation, 'Periodo Academico') ??
                    ''
          });
        }
      }
    }

    Map<String, Map<String, List>> sortedGroupedByDayAndSubject =
        Map.fromEntries(
      weekDaysOrder.where((day) => groupedByDayAndSubject.containsKey(day)).map(
            (day) => MapEntry(day, groupedByDayAndSubject[day]!),
          ),
    );

    return sortedGroupedByDayAndSubject;
  }

  String centerText(String text, {int width = 48}) {
    int spaces = (width - text.length) ~/ 2;
    return ' ' * spaces + text + ' ' * spaces;
  }

  String generateLine(String character, {int width = 42}) {
    return character * width;
  }

  String generateDoubleLine() {
    return generateLine('=');
  }

  String generateOneLine() {
    return generateLine('-');
  }
}
