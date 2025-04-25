import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/tv_template_model.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/image/image_controller.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

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
                  color: Colors.transparent,
                  child: Center(
                    child: CachedNetworkImage(
                      httpHeaders: const {
                        'User-Agent':
                            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
                      },
                      imageUrl: ctrl.currentItem.value.image?.url ?? '',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        ToolsHelper().writeLog(
                            '❌ Error cargando imagen: $url\nError: $error');
                        return Image.asset('assets/images/alt-banner.png');
                      },
                      placeholder: (context, url) {
                        ToolsHelper().writeLog('⏳ Cargando imagen: $url');
                        return Image.asset('assets/images/alt-banner.png');
                      },
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
