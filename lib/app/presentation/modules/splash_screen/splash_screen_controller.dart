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
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

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
      var token = generateQaToken;
      ToolsHelper.logger.i("WSO2", token.substring(token.length - 10));

      authService.setAwsToken(token);
      await Future.delayed(const Duration(seconds: 2));
      Get.offAndToNamed(Routes.template_static);
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

  String get generateQaToken {
    return "eyJ4NXQiOiJOVGRtWmpNNFpEazNOalkwWXpjNU1tWm1PRGd3TVRFM01XWXdOREU1TV"
        "dSbFpEZzROemM0WkE9PSIsImtpZCI6ImdhdGV3YXlfY2VydGlmaWNhdGVfYWxpYXMi"
        "LCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJVVFBMLkVEVS5FQ1wvZ"
        "GZzYXJtaWVudG9AY2FyYm9uLnN1cGVyIiwiYXBwbGljYXRpb24iOnsib3duZXIiOi"
        "JVVFBMLkVEVS5FQ1wvZGZzYXJtaWVudG8iLCJ0aWVyUXVvdGFUeXBlIjpudWxsLCJ0"
        "aWVyIjoiVW5saW1pdGVkIiwibmFtZSI6IkFwcCBNb3ZpbCBGbHV0dGVyIiwiaWQiOj"
        "EyMDMsInV1aWQiOiI4NWIzNjUyYi05NTc4LTQyZjAtYTA5NC1iMWU0YWUzNjNmMzMi"
        "fSwiaXNzIjoiaHR0cHM6XC9cL3Nydi1zaS0wMDEudXRwbC5lZHUuZWM6NDQzXC9vYX"
        "V0aDJcL3Rva2VuIiwidGllckluZm8iOnsiVW5saW1pdGVkIjp7InRpZXJRdW90YVR5"
        "cGUiOiJyZXF1ZXN0Q291bnQiLCJncmFwaFFMTWF4Q29tcGxleGl0eSI6MCwiZ3JhcGh"
        "RTE1heERlcHRoIjowLCJzdG9wT25RdW90YVJlYWNoIjp0cnVlLCJzcGlrZUFycmVzd"
        "ExpbWl0IjowLCJzcGlrZUFycmVzdFVuaXQiOm51bGx9fSwia2V5dHlwZSI6IlNBTkR"
        "CT1giLCJwZXJtaXR0ZWRSZWZlcmVyIjoiIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1Y"
        "nNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoiTW9iaWxl"
        "QXBpIiwiY29udGV4dCI6IlwvYXBpbVwvbW9iaWxlIiwicHVibGlzaGVyIjoiVVRQTC"
        "5FRFUuRUNcL2pzY2FsZGVyb24iLCJ2ZXJzaW9uIjoiMS4wLjAiLCJzdWJzY3JpcHR"
        "pb25UaWVyIjoiVW5saW1pdGVkIn0seyJzdWJzY3JpYmVyVGVuYW50RG9tYWluIjoiY"
        "2FyYm9uLnN1cGVyIiwibmFtZSI6Ik5ldENvcmVBcGkiLCJjb250ZXh0IjoiXC9hcGl"
        "tXC9uZXRjb3JlXC8xLjAiLCJwdWJsaXNoZXIiOiJVVFBMLkVEVS5FQ1wvanNjYWxkZ"
        "XJvbiIsInZlcnNpb24iOiIxLjAiLCJzdWJzY3JpcHRpb25UaWVyIjoiVW5saW1pdGV"
        "kIn1dLCJwZXJtaXR0ZWRJUCI6IiIsImlhdCI6MTY2Mzg1NDIzMywianRpIjoiMWU4M"
        "GE2NWUtMDU1Ny00MjBlLWEzNTQtMTQyYjc3OWIwZTA4In0=.eYmYie42NQkqkgOOpL"
        "LXLbukzmkR8xjlzKlg6nm7LaYe_ponEO5uKoZgG1FhTo9U4AbT2R7O2Zv9_Ly8WzuT"
        "ylROTsrsybGFvQ-mem-QQLF2sOIYFwzpbQMsG9gXnV50rmx1_LC3i5FrMPv2HX5Ktd"
        "RWdwAWTQSMp5fAutSLKsCUkzvCaW-nKWCIcBNtp4Mdiv3A80Sjdo1wexgLTlirwdFq"
        "F1uaj7juWOmtgKQJ2XReiyP7t4olGhVpIG9yqG7NJmJvaCoqE85OSp8dk-wvPJijTh"
        "PSan8uEIBp4-hweB-6ptpBzL91ddSOTFXfUgp3-9LkwIB_b7erLfDZZHsWPA==";
  }
}
