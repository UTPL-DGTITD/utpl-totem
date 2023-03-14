import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/weather_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class TemplateStaticController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  RxBool controllerVideo = false.obs;
  final title = 'UTPL+'.obs;
  // HACK taps
  DateTime? _lastTap;
  int _tapCount = 0;

  // WEATHER
  Rx<WeatherModel>? weather = WeatherModel().obs;
  final currentTemp = ''.obs;
  final currentUv = ''.obs;
  final currentDescTemp = ''.obs;
  final currentDescUv = ''.obs;
  final c = 0.obs;
  late Timer timerConection;
  late Timer timerTemp;

  RxString advices = 'La visión de la Universidad Técnica Particular de Loja es '
          'el humanismo de Cristo, que se traduce en sentido de perfección, en compromiso '
          'institucional, en servicio a la sociedad, en mejora continua y en la búsqueda '
          'constante de la excelencia. El humanismo de Cristo que, en su manifestación '
          'histórica y el desarrollo de su pensamiento en la tradición de la Iglesia '
          'Católica, propugna una universidad potenciadora, conforme a la dignidad que '
          'el ser humano tiene como “hijo de Dios” y que hace a la Universidad acoger, '
          'defender y promover en la sociedad, el producto y la reflexión de toda '
          'experiencia humana'
      .obs;

  // Rx<VideoPlayerController> controller =
  //     VideoPlayerController.asset('assets/videos/becas_utpl.mp4').obs
  //       ..value.initialize()
  //       ..value.play()
  //       ..value.setLooping(true);

  TemplateStaticController({
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
      loadWeather();
      // validateConection();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[template_static_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void validateConection() {
    timerConection.cancel();
    timerConection = Timer.periodic(const Duration(seconds: 5), (timer) async {
      ToolsHelper.logger.v('PROBANDO CONEXION');
      var status = await validateServerConnection();
      if (status) {
        timerConection.cancel();
        Get.offAndToNamed(Routes.splash_screen);
      }
      ToolsHelper.logger.v('INTERNET: $status');
    });
  }

  Future<bool> validateServerConnection() async {
    try {
      var result = await apiRepository.getBackendStatus();
      if (result.status == 200) {
        return true;
      }
      return false;
    } on SocketException {
      return false;
    } catch (error, stack) {
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
          // timerTemp = Timer(const Duration(minutes: 30), () {
          //   updateTemp();
          // });
          timerTemp = Timer.periodic(const Duration(seconds: 5), (timer) async {
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
    ToolsHelper.logger.v('ACTUALIZANDO');
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
        Get.offAndToNamed(Routes.template_static_2);
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
}
