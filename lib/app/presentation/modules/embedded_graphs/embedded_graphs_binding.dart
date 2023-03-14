import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/embedded_graphs/embedded_graphs_controller.dart';

class EmbeddedGraphsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmbeddedGraphsController>(
      () => EmbeddedGraphsController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
