import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mac_address/mac_address.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';
import 'package:utpl_totem/app/utils/validators/validators_forms.dart';

class ValidateController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final ValidatorsForm validatorsForm = ValidatorsForm();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<TextEditingController> descriptionController =
      TextEditingController(text: '').obs;
  //final tvCode = ''.obs;
  final currentTemplate = TvTemplateModel().obs;
  final responsive = Responsive();

  RxBool showSkeleton = false.obs;

  final title = 'Utpl Tv'.obs;

  final deviceCode = ''.obs;

  ValidateController({
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
      deviceCode.value = await PlatformDeviceId.getDeviceId ?? '';

      descriptionController.value.text = deviceCode.value;
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[validate_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void onChangeCode(String value) async {
    deviceCode.value = value;
  }

  void validateCode() async {
    if (isValidForm()) {
      try {
        toastService.presentLoading();
        var result = await apiRepository.getTvTemplateByCode(
          body: {
            "tv_code": deviceCode.value.trim(),
          },
        );
        switch (result.status) {
          case 200:
            currentTemplate.value = TvTemplateModel.fromJson(result.data);
            navigateToHomePage();
            toastService.hideLoading();
            break;
          case 404:
            toastService.presentWarningToast(
              text: "No existe el código ingresado",
            );
            toastService.hideLoading();
            break;

          default:
        }
      } on TimeoutException {
        toastService.hideLoading();
        navigateToTemplateOffline();
        toastService.presentWarningToast(
          text: "Tiempo de espera agotado",
        );
      } on SocketException {
        toastService.hideLoading();
        navigateToTemplateOffline();
        toastService.presentWarningToast(
          text: "Error de conexión",
        );
      } catch (error, stack) {
        toastService.hideLoading();
        navigateToTemplateOffline();
        ToolsHelper.logger.e(
          '[home_controller] (validate_code)',
          error,
          stack,
        );
        toastService.presentErrorToast(
          text: 'Error nuestro, intenta más tarde',
        );
      }
    } else {
      toastService.presentWarningToast(text: 'Los campos son necesarios');
    }
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void navigateToHomePage() {
    Get.toNamed(Routes.home, arguments: {
      'currentTemplate': currentTemplate.value,
    });
  }

  void navigateToTemplateOffline() {
    Get.offAndToNamed(Routes.template_offline);
  }
}
