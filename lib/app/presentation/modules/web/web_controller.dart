import 'package:get/get.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class WebController extends GetxController {
  final ToastService toastService;

  WebController({
    required this.toastService,
  });

  RxBool isLoading = true.obs;
  RxString title = ''.obs;
  RxString url = ''.obs;

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
  }
}
