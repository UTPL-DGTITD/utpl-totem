import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';
import 'package:webview_windows/webview_windows.dart';

class WebComponentController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final responsive = Responsive();

  final title = 'Web'.obs;

  RxBool isLoading = true.obs;
  RxString url = ''.obs;
  final controllerWebView = WebviewController().obs;
  final _textController = TextEditingController();

  WebComponentController({
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
    try {} catch (error, stack) {
      ToolsHelper.logger.e(
        '[web_component_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void loadUrl(String url) {
    this.url.value = url;
    loadWebView(url);
  }

  void loadWebView(String url) async {
    isLoading.value = true;
    await controllerWebView.value.initialize();
    controllerWebView.value.url.listen((url) {
      _textController.text = url;
    });
    await controllerWebView.value.setBackgroundColor(Colors.transparent);
    await controllerWebView.value
        .setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    await controllerWebView.value.loadUrl(url);
    isLoading.value = false;
  }
}
