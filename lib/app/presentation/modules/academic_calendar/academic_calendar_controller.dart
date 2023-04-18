import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/academic_calendar_model.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class AcademicCalendarController extends GetxController {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final activitiesDetails = <List<List<ActivityCalendarModel>>>[].obs;
  final modalitiesDetails = <GenericListItemModel>[].obs;
  final test = <List<List<ActivityCalendarModel>>>[].obs;
  final showLoadingModalities = false.obs;
  final showLoadingCalendars = false.obs;
  final selectedIndexModality = 0.obs;
  final selectedIdModality = ''.obs;
  final responsive = Responsive();
  final selectedModality = ''.obs;
  final hasModality = false.obs;
  final hasCalendar = false.obs;

  RxString title = 'Calendario Académico'.obs;
  RxList<dynamic> isOpen = [].obs;
  RxBool showSkeleton = true.obs;
  RxBool isLogged = false.obs;
  RxString msJwt = ''.obs;

  AcademicCalendarController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
    required this.authService,
  });

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  void _initConfig() async {
    try {
      loadModalities();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[academic_calendar_controller] (_initConfig) ',
        error,
        stack,
      );
      toastService.hideLoading();
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void onChangeModality(String category, int index, String id) {
    selectedModality.value = category;
    selectedIndexModality.value = index;
    selectedIdModality.value = id;
    loadCalendarsByModality();
  }

  void loadModalities() async {
    try {
      showSkeleton.value = true;
      showLoadingModalities.value = true;

      var result = await apiRepository.getAcademicCalendarModalities();
      switch (result.status) {
        case 200:
          modalitiesDetails
              .assignAll(genericListItemModelFromList(result.data));
          selectedModality.value = modalitiesDetails.first.title;
          selectedIdModality.value = modalitiesDetails.first.id;
          if (modalitiesDetails.isNotEmpty) {
            hasModality.value = true;
          }
          loadCalendarsByModality();

          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      showLoadingModalities.value = false;
      showSkeleton.value = false;
    } on TimeoutException {
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
      // Get.offNamedUntil(Routes.network_error, (route) => false);
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[academic_calendar_controller] (loadModalities)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void loadCalendarsByModality() async {
    try {
      showLoadingCalendars.value = true;
      hasCalendar.value = false;

      activitiesDetails.clear();
      isOpen.clear();

      var result = await apiRepository.getActivitiesByModality(
          idModality: selectedIdModality.value);
      switch (result.status) {
        case 200:
          activitiesDetails
              .assignAll(activityCalendarModelFromList(result.data));
          if (modalitiesDetails.isNotEmpty) {
            hasCalendar.value = true;
          }
          if (activitiesDetails.length == 1) {
            isOpen.add(true.obs);
          } else {
            // ignore: unused_local_variable
            for (var attr in activitiesDetails) {
              isOpen.add(false.obs);
            }
          }
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      showLoadingCalendars.value = false;
    } on TimeoutException {
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
      Get.offNamedUntil(Routes.network_error, (route) => false);
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[academic_calendar_controller] (loadCalendarsByModality)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  String getProgramCalendar(String program) {
    if (program == 'todos') {
      program = 'general';
    }
    if (program == 'mad') {
      program = 'Abierta y a Distancia';
    }
    return program.toUpperCase();
  }
}
