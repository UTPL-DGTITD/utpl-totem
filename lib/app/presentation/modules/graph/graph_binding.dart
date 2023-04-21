import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/graph/graph_controller.dart';

class GraphBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GraphController>(
      () => GraphController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
