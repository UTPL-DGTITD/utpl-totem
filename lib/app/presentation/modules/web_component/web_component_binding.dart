import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/web_component/web_component_controller.dart';

class WebComponentBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebComponentController>(
      () => WebComponentController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
