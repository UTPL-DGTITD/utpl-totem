import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/screen_protector/screen_protector_controller.dart';

class ScreenProtectorBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScreenProtectorController>(
      () => ScreenProtectorController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
