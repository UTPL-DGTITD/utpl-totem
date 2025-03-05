import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/events/events_controller.dart';

class EventsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventsController>(
      () => EventsController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
