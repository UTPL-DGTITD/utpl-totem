import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/observatories/observatory_detail/observatory_detail_controller.dart';

class ObservatoryDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ObservatoryDetailController>(
      () => ObservatoryDetailController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
