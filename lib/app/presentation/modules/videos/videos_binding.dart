import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/videos/videos_controller.dart';

class VideosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideosController>(
      () => VideosController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
