import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/tv_template_model.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/image/image_controller.dart';

class ImagePage extends GetView<ImageController> {
  final TvTemplateBody item;
  const ImagePage(this.item, {super.key});

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
            color: Color.fromARGB(255, 232, 13, 13),
            child: Center(
              child: CachedNetworkImage(
                httpHeaders: const {
                  'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64)',
                },
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
              : const SizedBox();
        },
      ),
    );
  }
}
