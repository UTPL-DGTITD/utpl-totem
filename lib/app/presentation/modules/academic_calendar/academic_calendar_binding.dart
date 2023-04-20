import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/academic_calendar/academic_calendar_controller.dart';

class AcademicCalendarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AcademicCalendarController>(
      () => AcademicCalendarController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        //authService: Get.find(),
      ),
    );
  }
}
