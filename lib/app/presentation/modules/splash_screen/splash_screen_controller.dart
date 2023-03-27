import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class SplashScreenController extends GetxController {
  final LocalRepository localRepository;
  final AuthService authService;
  final ToastService toastService = Get.find<ToastService>();
  final ApiRepository apiRepository = Get.find<ApiRepository>();

  final Responsive responsive = Responsive();

  Rx<String> subtitle = ''.obs;

  final deviceCode = ''.obs;
  final currentTemplate = TvTemplateModel().obs;

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
      var token = generateQaToken;
      ToolsHelper.logger.i("WSO2", token.substring(token.length - 10));
      authService.setAwsToken(token);
      validateCode();
      // await Future.delayed(const Duration(seconds: 2));
      // Get.offAndToNamed(Routes.template_static);
    } else {
      navigateToTemplateOffline();
    }
  }

  void navigateToHomePage() {
    Get.offAllNamed(Routes.home, arguments: {
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

  String get generateQaToken {
    return "eyJ4NXQiOiJOVGRtWmpNNFpEazNOalkwWXpjNU1tWm1PRGd3TVRFM01XWXdOREU1TVdSbFpEZzROemM0WkE9PSIsImtpZCI6ImdhdGV3YXlfY2VydGlmaWNhdGVfYWxpYXMiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJVVFBMLkVEVS5FQ1wvZGZzYXJtaWVudG9AY2FyYm9uLnN1cGVyIiwiYXBwbGljYXRpb24iOnsib3duZXIiOiJVVFBMLkVEVS5FQ1wvZGZzYXJtaWVudG8iLCJ0aWVyUXVvdGFUeXBlIjpudWxsLCJ0aWVyIjoiVW5saW1pdGVkIiwibmFtZSI6IkFwcCBNb3ZpbCBGbHV0dGVyIiwiaWQiOjEyMDMsInV1aWQiOiI4NWIzNjUyYi05NTc4LTQyZjAtYTA5NC1iMWU0YWUzNjNmMzMifSwiaXNzIjoiaHR0cHM6XC9cL3Nydi1zaS0wMDEudXRwbC5lZHUuZWM6NDQzXC9vYXV0aDJcL3Rva2VuIiwidGllckluZm8iOnsiVW5saW1pdGVkIjp7InRpZXJRdW90YVR5cGUiOiJyZXF1ZXN0Q291bnQiLCJncmFwaFFMTWF4Q29tcGxleGl0eSI6MCwiZ3JhcGhRTE1heERlcHRoIjowLCJzdG9wT25RdW90YVJlYWNoIjp0cnVlLCJzcGlrZUFycmVzdExpbWl0IjowLCJzcGlrZUFycmVzdFVuaXQiOm51bGx9fSwia2V5dHlwZSI6IlBST0RVQ1RJT04iLCJwZXJtaXR0ZWRSZWZlcmVyIjoiIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoiTW9iaWxlQXBpIiwiY29udGV4dCI6IlwvYXBpbVwvbW9iaWxlIiwicHVibGlzaGVyIjoiVVRQTC5FRFUuRUNcL2pzY2FsZGVyb24iLCJ2ZXJzaW9uIjoiMS4wLjAiLCJzdWJzY3JpcHRpb25UaWVyIjoiVW5saW1pdGVkIn0seyJzdWJzY3JpYmVyVGVuYW50RG9tYWluIjoiY2FyYm9uLnN1cGVyIiwibmFtZSI6Ik5ldENvcmVBcGkiLCJjb250ZXh0IjoiXC9hcGltXC9uZXRjb3JlXC8xLjAiLCJwdWJsaXNoZXIiOiJVVFBMLkVEVS5FQ1wvanNjYWxkZXJvbiIsInZlcnNpb24iOiIxLjAiLCJzdWJzY3JpcHRpb25UaWVyIjoiVW5saW1pdGVkIn1dLCJwZXJtaXR0ZWRJUCI6IiIsImlhdCI6MTY2Mzg1NDE0OCwianRpIjoiNDVkNmEwZWEtZDljNy00ZTNjLTg4YWEtOWUyYjQzZDM2MGE4In0=.tTCKnScwg6VNFzZRrLJGPetb-Isv34iGCM_eGNiHQL5h3ogc_ZlYegavEPDPRj6zsbfbeaaxoSuCwQHr9g6lcqc7BxpNodQOw6POJ68JrvYvbB_6HqG4qNbuyFx5P5xgNGLXrvm1Z3-TOdl4q0jIF5kL4JGvmX7Y2TNLwolCyIhFi6Q13JEquEEWn1JiavPwwI4N4jNSkjpe7fdMdg-Uj1SoYwpaOazKAyRvKDmt2fDjePR7t1YC5UWGuOkGP5-8Jyw3fpn9X9XQXCme5icmlaGtgg14mKKyipfOqU58es4WwBzkAJwY3nuIIvEkO60CT69IT226TlsgC7C3XkhiDQ==";
  }

  void validateCode() async {
    try {
      deviceCode.value = await PlatformDeviceId.getDeviceId ?? '';
      deviceCode.value = deviceCode.trim();
      ToolsHelper.logger.v('-${deviceCode.trim()}-');
      //deviceCode.value = '5F6B4244-F2D7-B34D-A01D-1593561B9E98';
      //deviceCode.value = '03000200-0400-0500-0006-000700080009';
      var result = await apiRepository.getTvTemplateByCode(
        body: {
          "tv_code": deviceCode.value,
        },
      );
      switch (result.status) {
        case 200:
          currentTemplate.value = TvTemplateModel.fromJson(result.data);
          navigateToHomePage();
          // toastService.hideLoading();
          break;
        case 404:
          Get.offAndToNamed(Routes.validate);
          toastService.presentWarningToast(
            text: "No existe dispositivo, ingresar un código válido",
          );
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
        '[splash_screen_controller] (validate_code)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }
}
