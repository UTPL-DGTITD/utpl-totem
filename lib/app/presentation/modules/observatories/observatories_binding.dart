import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/observatories/observatories_controller.dart';

class ObservatoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ObservatoriesController>(
      () => ObservatoriesController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
