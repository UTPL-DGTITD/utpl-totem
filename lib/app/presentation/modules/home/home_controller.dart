import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/data/models/weather_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  RxBool controllerVideo = false.obs;
  final title = 'UTPL+'.obs;
  DateTime? _lastTap;
  int _tapCount = 0;

  // WEATHER
  Rx<WeatherModel>? weather = WeatherModel().obs;
  Rx<GenericListItemModel> wallpaper = GenericListItemModel().obs;
  Rx<GenericListItemModel> notifies = GenericListItemModel().obs;
  final currentTemp = ''.obs;
  final currentUv = ''.obs;
  final currentDescTemp = ''.obs;
  final currentDescUv = ''.obs;
  //late Timer timerConection;
  late Timer timerTemp;
  late Timer inactivityTimer = Timer(const Duration(minutes: 20), () {});
  final currentTemplate = TvTemplateModel().obs;
  late Timer timerReset;

  RxString utplMessage = 'La visión de la Universidad Técnica Particular de Loja es '
          'el humanismo de Cristo, que se traduce en sentido de perfección, en compromiso '
          'institucional, en servicio a la sociedad, en mejora continua y en la búsqueda '
          'constante de la excelencia. El humanismo de Cristo que, en su manifestación '
          'histórica y el desarrollo de su pensamiento en la tradición de la Iglesia '
          'Católica, propugna una universidad potenciadora, conforme a la dignidad que '
          'el ser humano tiene como “hijo de Dios” y que hace a la Universidad acoger, '
          'defender y promover en la sociedad, el producto y la reflexión de toda '
          'experiencia humana'
      .obs;
  RxString notify = ''.obs;
  Rx<Color> colorNotify = Colors.transparent.obs;
  Rx<Color> colorTextNotify = Get.theme.cardColor.obs;

  // Rx<VideoPlayerController> controller =
  //     VideoPlayerController.asset('assets/videos/becas_utpl.mp4').obs
  //       ..value.initialize()
  //       ..value.play()
  //       ..value.setLooping(true);

  HomeController({
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
    closeTimers();
    super.onClose();
  }

  void closeTimers() {
    ToolsHelper.logger.v('CERRANDO TIMERS');
    //timerConection.isActive ? timerConection.cancel() : null;
    timerTemp.isActive ? timerTemp.cancel() : null;
    inactivityTimer.isActive ? inactivityTimer.cancel() : null;
    timerReset.isActive ? timerReset.cancel() : null;
  }

  void _initConfig() async {
    try {
      notify = utplMessage;
      _loadRouteParams();
      loadWeather();
      loadWallpaper();
      loadNotify();
      //updateColorNotify('success');
      // validateConection();
      startTimer(const Duration(minutes: 20));
      timerReset = Timer(const Duration(hours: 5), () {
        closeTimers();
        Get.offAllNamed(Routes.splash_screen, arguments: {
          'currentTemplate': currentTemplate.value,
        });
      });
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
    ToolsHelper.logger.v('TEMPLATE RECIBIDO');
    final params = Get.arguments;
    assert(params != null, 'Params is required');
    assert(params['currentTemplate'] != null, 'currentTemplate is required');
    assert(params['currentTemplate'] is TvTemplateModel,
        'currentTemplate type is not TvTemplateModel');
    currentTemplate.value = params['currentTemplate'];
  }

  // void validateConection() {
  //   timerConection.cancel();
  //   timerConection = Timer.periodic(const Duration(minutes: 1), (timer) async {
  //     ToolsHelper.logger.v('PROBANDO CONEXION');
  //     var status = await validateServerConnection();
  //     if (status) {
  //       timerConection.cancel();
  //       Get.offAndToNamed(Routes.splash_screen);
  //     }
  //     ToolsHelper.logger.v('INTERNET: $status');
  //   });
  // }

  Future<bool> validateServerConnection() async {
    try {
      var result = await apiRepository.getBackendStatus();
      if (result.status == 200) {
        return true;
      }
      return false;
    } on SocketException {
      return false;
    } catch (error) {
      return false;
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

          timerTemp = Timer.periodic(const Duration(minutes: 1), (timer) async {
            updateTemp();
            loadNotify();
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
    //ToolsHelper.logger.v('ACTUALIZANDO');
    var actualHour = DateTime.now().hour;
    for (Hour item in weather!.value.hours ?? []) {
      var splitted = item.interval.split(':');
      var compare = int.parse(splitted[0]);

      if (actualHour >= compare && actualHour < (compare + 3)) {
        currentTemp.value = item.temp;
        currentUv.value = item.uvIndex;
        currentDescTemp.value = item.symbolDescription;
        if (double.parse(currentUv.value) <= 2) {
          currentDescUv.value = 'Baja';
        } else if ((double.parse(currentUv.value) > 2) &&
            (double.parse(currentUv.value) <= 5)) {
          currentDescUv.value = 'Moderada';
        } else if ((double.parse(currentUv.value) > 5) &&
            (double.parse(currentUv.value) <= 7)) {
          currentDescUv.value = 'Alta';
        } else if ((double.parse(currentUv.value) > 7) &&
            (double.parse(currentUv.value) <= 10)) {
          currentDescUv.value = 'Muy alta';
        } else {
          currentDescUv.value = 'Extrema';
        }
      }
    }
  }

  void refreshTemplate() {
    if (_lastTap != null &&
        DateTime.now().difference(_lastTap!).inSeconds < 2) {
      _tapCount++;
      _lastTap = DateTime.now();
      if (_tapCount == 10) {
        _tapCount = 0;
        _lastTap = null;

        inactivityTimer.cancel();
        ToolsHelper.logger.v('RESET TEMPLATE');
        closeTimers();
        Get.offAllNamed(Routes.splash_screen, arguments: {
          'currentTemplate': currentTemplate.value,
        });
      }
    } else {
      _tapCount = 1;
      _lastTap = DateTime.now();
      Future.delayed(const Duration(seconds: 3), () {
        _tapCount = 0;
        _lastTap = null;
      });
    }
  }

  void startTimer(Duration duration) {
    //inactivityTimer = Timer(const Duration(minutes: 20), () async {
    inactivityTimer = Timer(duration, () async {
      ToolsHelper.logger.v('INACTIVIDAD USUARIO');
      if (Get.currentRoute == Routes.home) {
        navigateToPage(Routes.screen_protector);
      } else {
        Get.until((route) => Get.currentRoute == Routes.home);
        resetTimer();
      }

      ToolsHelper.logger.v('VOLVISTE AL HOME');
      //resetTimer();
    });
  }

  void resetTimer({Duration duration = const Duration(minutes: 20)}) {
    stopTimer();
    startTimer(duration);
  }

  void stopTimer() {
    if (inactivityTimer.isActive) {
      inactivityTimer.cancel();
    }
  }

  void navigateToPage(String page) async {
    switch (page) {
      case Routes.screen_protector:
        resetTimer(duration: const Duration(minutes: 30));
        break;
      default:
        resetTimer(duration: const Duration(minutes: 5));
    }

    await Get.toNamed(page, arguments: {
      "wallpaper": wallpaper.value,
    });
    resetTimer();
  }

  void loadWallpaper() async {
    try {
      showSkeleton.value = true;
      var result = await apiRepository
          .getWallpaper(body: {"enable": true, "source": "totem"});
      switch (result.status) {
        case 200:
          wallpaper.value = GenericListItemModel.fromJson(result.data);
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
        '[home_controller] (loadWallpaper)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void loadNotify() async {
    try {
      //showSkeleton.value = true;
      var result = await apiRepository.getNotify();
      switch (result.status) {
        case 200:
          notifies.value = GenericListItemModel.fromJson(result.data);
          notify.value = notifies.value.description;
          updateColorNotify(notifies.value.typeNotify);
          ToolsHelper.logger.v('RESULT NOTIFY 200');
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
        '[home_controller] (loadNotify)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void updateColorNotify(String type) {
    switch (type) {
      case 'warning':
        colorNotify.value = const Color(0xFFFFF4C8);
        colorTextNotify.value = const Color(0xFF8A6400);
        break;
      case 'info':
        //colorNotify.value = const Color(0xFFCBEDF3);
        //colorTextNotify.value = const Color(0xFF005562);
        colorNotify.value = Colors.transparent;
        colorTextNotify.value = Get.theme.cardColor;
        break;
      case 'success':
        colorNotify.value = const Color(0xFFCEEED8);
        colorTextNotify.value = const Color(0xFF01591C);
        break;
      case 'danger':
        colorNotify.value = const Color(0xFFFED5DB);
        colorTextNotify.value = const Color(0xFF7B1021);
        break;
      default:
        colorNotify.value = Colors.transparent;
        colorTextNotify.value = Get.theme.cardColor;
        notify = utplMessage;
    }
  }
}
