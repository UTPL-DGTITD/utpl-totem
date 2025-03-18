import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/videos_module/videos_module_controller.dart';

class VideosModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideosModuleController>(() => VideosModuleController());
  }
}
