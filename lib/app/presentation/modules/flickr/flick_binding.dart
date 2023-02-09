import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/flickr/flick_controller.dart';

class FlickBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlickrController>(
      () => FlickrController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
