import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/youtube_videos/youtube_videos_controller.dart';

class YoutubeVideosBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YoutubeVideosController>(
      () => YoutubeVideosController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
