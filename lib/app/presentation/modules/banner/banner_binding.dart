import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/banner/banner_controller.dart';

class BannerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BannerController>(
      () => BannerController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
