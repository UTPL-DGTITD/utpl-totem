import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/investigation/investigation_controller.dart';

class InvestigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvestigationController>(
      () => InvestigationController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
