import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class EventsController extends GetxController with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  final title = 'Eventos UTPL'.obs;

  RxList<GenericListItemModel> events = <GenericListItemModel>[].obs;
  RxBool loadingEvents = false.obs;
  final pageEvents = 1.obs;
  final ScrollController scrollController = ScrollController();

  EventsController({
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
      await loadEvents();
      addListenerEvents();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[events_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  Future<void> loadEvents() async {
    try {
      showSkeleton.value = true;
      var result = await apiRepository.getEventsPreview();
      switch (result.status) {
        case 200:
          events.assignAll(genericListItemModelFromList(result.data));
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      showSkeleton.value = false;
    } on TimeoutException {
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[events_controller] (loadEvents)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void loadMoreEvents() async {
    loadingEvents.value = true;

    pageEvents.value++;
    try {
      var result = await apiRepository.getNewsPreview(page: pageEvents.value);
      switch (result.status) {
        case 200:
          events.addAll(genericListItemModelFromList(result.data));
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      loadingEvents.value = false;
    } on TimeoutException {
      loadingEvents.value = false;
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      loadingEvents.value = false;
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      loadingEvents.value = false;
      ToolsHelper.logger.e(
        '[home_controller] (loadMoreNews)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void addListenerEvents() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          (scrollController.position.maxScrollExtent)) {
        loadMoreEvents();
      }
    });
  }
}
