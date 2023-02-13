import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/template_static_2/template_static_controller.dart';

class TemplateStaticBinding2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplateStaticController2>(
      () => TemplateStaticController2(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
