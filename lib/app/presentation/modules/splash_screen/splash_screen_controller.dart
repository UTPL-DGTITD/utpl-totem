import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/responsive.dart';

class SplashScreenController extends GetxController {
  final LocalRepository localRepository;
  final AuthService authService;
  final ToastService toastService = Get.find<ToastService>();
  final ApiRepository apiRepository = Get.find<ApiRepository>();

  final Responsive responsive = Responsive();

  Rx<String> subtitle = ''.obs;

  final tvCode = ''.obs;
  final currentTemplate = TvTemplateModel().obs;
  final macAddress = ''.obs;

  SplashScreenController({
    required this.localRepository,
    required this.authService,
  });

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  void _initConfig() async {
    var status = await validateServerConnection();
    if (status) {
      await Future.delayed(const Duration(seconds: 2));
      Get.offAndToNamed(Routes.template_static_2);
    } else {
      navigateToTemplateOffline();
    }
  }

  void navigateToHomePage() {
    Get.toNamed(Routes.home, arguments: {
      'currentTemplate': currentTemplate.value,
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

  void navigateToTemplateOffline() {
    Get.offAndToNamed(Routes.template_offline);
  }
}
