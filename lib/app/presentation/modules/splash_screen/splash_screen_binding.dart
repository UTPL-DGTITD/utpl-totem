import 'package:utpl_totem_oficial/app/presentation/modules/splash_screen/splash_screen_controller.dart';
import 'package:get/get.dart';

class SplashScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashScreenController>(
      SplashScreenController(
        localRepository: Get.find(),
      ),
    );
  }
}
