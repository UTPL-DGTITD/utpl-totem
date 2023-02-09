import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/template_static/template_static_controller.dart';

class TemplateStaticBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplateStaticController>(
      () => TemplateStaticController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
