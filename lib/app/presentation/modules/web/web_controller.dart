import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';
import 'package:webview_windows/webview_windows.dart';

class WebController extends GetxController {
  final ToastService toastService;

  WebController({
    required this.toastService,
  });

  RxBool isLoading = true.obs;
  RxString title = ''.obs;
  RxString url = ''.obs;

  final controllerWebView = WebviewController().obs;
  final _textController = TextEditingController();
  Rx<bool> isWebviewSuspended = false.obs;

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  void _initConfig() async {
    toastService.presentLoading();
    try {
      _loadRouteParams();
      toastService.hideLoading();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[web_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.hideLoading();
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void _loadRouteParams() {
    final params = Get.arguments;
    assert(params != null, 'Params is required');
    assert(params['url'] != null, 'url is required');
    assert(params['url'] is String, 'url must be a String');
    assert(params['title'] != null, 'title is required');
    assert(params['title'] is String, 'title must be a String');
    url.value = params['url'];
    title.value = params['title'];
    loadWebView(url.value);
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
