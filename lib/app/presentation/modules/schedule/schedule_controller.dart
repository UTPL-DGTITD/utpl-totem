import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/extra_base_model.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/models/generic_schedule_model.dart';
import 'package:utpl_totem/app/data/models/related_base_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/widgets/modal_dialog_schedule.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';
import 'package:utpl_totem/app/utils/validators/validators_forms.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class ScheduleController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

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
    required this.authService,
  });

  @override
  void onInit() {
    _initConfig();
    tabs = [
      Tab(
        iconMargin: EdgeInsets.symmetric(),
        text: 'Por usuario',
        height: responsive.hp(7),
        icon: Icon(
          Icons.person,
          size: responsive.ip(3),
        ),
      ),
      Tab(
        iconMargin: EdgeInsets.symmetric(),
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

  @override
  void onClose() {
    super.onClose();
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
      ScheduleController ctrl, Datum datum) {
    ModalDialogSchedule.alertSchedule(context, item, ctrl, datum);
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
}
