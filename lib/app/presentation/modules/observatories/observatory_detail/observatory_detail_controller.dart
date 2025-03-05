import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/end_point_base_model.dart';
import 'package:utpl_totem_oficial/app/data/models/observatory_detail_model.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/routes/app_pages.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/uri_helper.dart';
import 'package:utpl_totem_oficial/app/utils/types/request_method_endpoint_type.dart';

class ObservatoryDetailController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = true.obs;
  Rx<EndPointBaseModel> endPoint = EndPointBaseModel().obs;
  Rx<ObservatoryDetailModel> observatory = ObservatoryDetailModel().obs;
  RxString title = 'Detalle Observatorio'.obs;
  RxBool hasObservatory = false.obs;
  ScrollController contentScrollController = ScrollController();
  ScrollController scrollController = ScrollController();
  late Timer timerAnimate;

  ObservatoryDetailController({
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
      _loadRouteParams();
      _loadInformation(endPoint.value);
      timerAnimate = Timer.periodic(const Duration(seconds: 5), (timer) async {
        animateList();
      });
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[observatory_detail_controller] (_initConfig)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void _loadRouteParams() {
    final params = Get.arguments;
    assert(params != null, 'Params is required');
    assert(params['endpoint'] != null, 'endpoint is required');
    assert(params['endpoint'] is EndPointBaseModel,
        'endpoint is not type EndPointBaseModel');
    endPoint.value = params['endpoint'];
  }

  void _loadInformation(EndPointBaseModel endPoint) async {
    final composedEndPoint = await UriHelper.composeEndPoint(endPoint);

    try {
      switch (endPoint.method) {
        case RequestMethodEndpointType.get:
          var result = await apiRepository.getGenericObservatory(
            url: composedEndPoint['url_base'],
            path: composedEndPoint['url_path'],
          );
          observatory.value = result;
          if (observatory.value.image != '') {
            hasObservatory.value = true;
          }

          break;
        default:
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
        '[observatory_detail_controller] (_loadInformation)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Ocurrió un error, intenta nuevamente.',
      );
    }
  }

  void moveLeft() {
    scrollController.animateTo(
      scrollController.offset - responsive.wp(50),
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
  }

  void moveRight() {
    scrollController.animateTo(
      scrollController.offset + responsive.wp(50),
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
  }

  void animateList() {
    if (scrollController.offset != scrollController.position.maxScrollExtent) {
      moveRight();
    } else {
      scrollController.animateTo(
        0,
        curve: Curves.linear,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  String getUserSplitEmail(String email) {
    List<String> partes = email.split("@");
    return partes[0];
  }

  void navigateToUrl(String url) {
    url =
        'https://smartland.maps.arcgis.com/apps/dashboards/565fc2eccbc7488db6639233cf555c83';
    Get.toNamed(Routes.web, arguments: {
      "url": url,
      "title": title.value,
    });
  }
}
