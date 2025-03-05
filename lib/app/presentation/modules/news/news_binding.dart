import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/news/news_controller.dart';

class NewsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(
      () => NewsController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
