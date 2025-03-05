import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/schedule/schedule_controller.dart';

class ScheduleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(
      () => ScheduleController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
