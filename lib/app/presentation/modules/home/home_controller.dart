import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:utpl_totem/app/controllers/main_controller.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/data/models/weather_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final mainCtrl = Get.find<MainController>();
  final responsive = Responsive();

  RxBool showSkeleton = false.obs;

  RxList<GenericListItemModel> news = <GenericListItemModel>[].obs;
  Rx<WeatherModel>? weather = WeatherModel().obs;
  final currentTemp = ''.obs;
  late Timer timerTemp;
  final title = 'Utpl Tv'.obs;

  final pageNews = 1.obs;

  final currentTemplate = TvTemplateModel().obs;

  HomeController({
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
      _loadRouteParams();
      await loadWeather();
      await loadNews();
      ToolsHelper.logger.v('INICIO');
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[home_controller] (_initConfig)',
        error,
        stack,
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
    assert(params['currentTemplate'] != null, 'currentTemplate is required');
    assert(params['currentTemplate'] is TvTemplateModel,
        'currentTemplate type is not TvTemplateModel');
    currentTemplate.value = params['currentTemplate'];
  }

  Future<void> loadNews() async {
    try {
      showSkeleton.value = true;
      var result = await apiRepository.getNewsPreview();
      switch (result.status) {
        case 200:
          news.assignAll(genericListItemModelFromList(result.data));
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
        '[home_controller] (loadNews)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  Future<void> loadWeather() async {
    try {
      showSkeleton.value = true;
      var result = await apiRepository.getWeather();
      switch (result.status) {
        case 200:
          weather?.value = WeatherModel.fromJson(result.data);
          updateTemp();
          timerTemp = Timer(const Duration(minutes: 30), () {
            updateTemp();
          });
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
        '[home_controller] (loadWeather)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void updateTemp() {
    var actualHour = DateTime.now().hour;
    for (Hour item in weather!.value.hours ?? []) {
      var splitted = item.interval.split(':');
      var compare = int.parse(splitted[0]);

      if (actualHour >= compare && actualHour < (compare + 3)) {
        currentTemp.value = item.temp;
      }
    }
  }

  String loadAdvices() {
    var advices = '';
    for (GenericListItemModel item in news) {
      advices = '$advices              ${item.title}';
    }
    return advices;
  }
}
