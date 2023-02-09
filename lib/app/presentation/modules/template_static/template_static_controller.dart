import 'dart:async';
import 'dart:io';

import 'package:ext_video_player/ext_video_player.dart';
import 'package:get/get.dart';
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

  var cont = 0.obs;
  Timer timerTemp = Timer(const Duration(seconds: 5), () {});
  Rx<VideoPlayerController> controller =
      VideoPlayerController.asset('assets/videos/becas_utpl.mp4').obs
        ..value.initialize()
        ..value.play()
        ..value.setLooping(true);

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
      controllerVideo.value = true;
      // validateConection();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[template_offline_controller] (_initConfig)',
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
    timerTemp.cancel();
    timerTemp = Timer.periodic(const Duration(seconds: 5), (timer) async {
      ToolsHelper.logger.v('PROBANDO CONEXION');
      var status = await validateServerConnection();
      if (status) {
        timerTemp.cancel();
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
}
