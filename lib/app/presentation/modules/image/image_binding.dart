import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/image/image_controller.dart';

class ImageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageController>(
      () => ImageController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
