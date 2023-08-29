import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/presentation/modules/image/image_controller.dart';

class ImagePage extends GetView<ImageController> {
  final TvTemplateBody item;
  const ImagePage(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      ImageController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
    ctrl.currentItem.value = item;
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<ImageController>(
        init: ImageController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return ctrl.title.value.isNotEmpty
              ? Container(
                  color: Get.theme.cardColor,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: ctrl.currentItem.value.image?.url ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (context, a, b) {
                        return Image.asset('assets/images/alt-banner.png');
                      },
                      placeholder: (context, url) =>
                          Image.asset('assets/images/alt-banner.png'),
                    ),
                  ),
                )
              : SizedBox();
        },
      ),
    );
  }
}
