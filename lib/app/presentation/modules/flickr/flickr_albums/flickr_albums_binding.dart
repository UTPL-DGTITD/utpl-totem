import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/flickr/flickr_albums/flickr_albums_controller.dart';

class FlickrAlbumsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlickrAlbumsController>(
      () => FlickrAlbumsController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
