import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/validate/validate_controller.dart';

class ValidateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ValidateController>(
      () => ValidateController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
