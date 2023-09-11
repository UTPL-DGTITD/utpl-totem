import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/bus_routes/bus_schedule_controller.dart';

class BusScheduleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusScheduleController>(
      () => BusScheduleController(
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
