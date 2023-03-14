import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/ranking/ranking_controller.dart';

class RankingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RankingController>(
      () => RankingController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
