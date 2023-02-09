import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/web/web_controller.dart';

class WebBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebController>(
      () => WebController(
        toastService: Get.find(),
      ),
    );
  }
}
