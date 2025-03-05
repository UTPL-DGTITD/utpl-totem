import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/flickr/flickr_album_detail/flickr_album_detail_controller.dart';

class FlickrAlbumDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FlickrAlbumDetailController>(
      () => FlickrAlbumDetailController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
  }
}
