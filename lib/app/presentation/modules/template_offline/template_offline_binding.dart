import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/template_offline/template_offline_controller.dart';

class TemplateOfflineBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplateOfflineController>(
      () => TemplateOfflineController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
