import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/routes/app_pages.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';
import 'package:utpl_totem_oficial/app/utils/types/interaction_generic_item_type.dart';

class ObservatoriesController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  RxString title = 'Observatorios'.obs;
  ScrollController scrollController = ScrollController();
  late Timer timerAnimate =
      Timer.periodic(const Duration(seconds: 5), (timer) {});
  RxList<GenericListItemModel> observatories = <GenericListItemModel>[].obs;

  ObservatoriesController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
  });

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  @override
  void onClose() {
    if (timerAnimate.isActive) {
      timerAnimate.cancel();
    }
    super.onClose();
  }

  void _initConfig() async {
    try {
      await loadObservatories();
      timerAnimate = Timer.periodic(const Duration(seconds: 5), (timer) async {
        animateList();
      });
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[observatories_controller] (_initConfig)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void moveLeft() {
    scrollController.animateTo(
      scrollController.offset - responsive.wp(25),
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
  }

  void moveRight() {
    scrollController.animateTo(
      scrollController.offset + responsive.wp(25),
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> loadObservatories() async {
    try {
      var result = await apiRepository.getObservatories();
      switch (result.status) {
        case 200:
          observatories.assignAll(genericListItemModelFromList(result.data));
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
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
        '[observatories_controller] (loadInvestigations)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Ocurrió un error, intenta nuevamente.',
      );
    }
  }

  void navigateToDetail(GenericListItemModel observatory) {
    if (observatory.interaction == InteractionGenericItemType.endPoint) {
      if (observatory.endpoint != null) {
        Get.toNamed(Routes.observatory_detail, arguments: {
          "endpoint": observatory.endpoint,
        });
      }
    } else {
      toastService.presentWarningToast(
        text: "Por el momento no se puede visualizar este elemento",
      );
    }
  }

  void animateList() {
    if (scrollController.hasClients) {
      if (scrollController.offset !=
          scrollController.position.maxScrollExtent) {
        moveRight();
      } else {
        scrollController.animateTo(
          0,
          curve: Curves.linear,
          duration: const Duration(milliseconds: 500),
        );
      }
    }
  }
}
