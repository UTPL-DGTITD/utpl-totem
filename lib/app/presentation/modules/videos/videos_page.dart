import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/presentation/modules/videos/videos_controller.dart';

class VideosPage extends GetView<VideosController> {
  final TvTemplateBody item;
  const VideosPage(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ctrl = Get.put(
    //   VideosController(
    //     localRepository: Get.find(),
    //     apiRepository: Get.find(),
    //     toastService: Get.find(),
    //     authService: Get.find(),
    //   ),
    // );
    //ctrl.urlVideos.value = item.embeddedYoutube;
    //ctrl.player.play();
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<VideosController>(
        init: VideosController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (ctrl) {
          ctrl.controller!.urlVideos.value = item.embeddedYoutube;
        },
        builder: (ctrl) {
          return SafeArea(
            child: ctrl.showSkeleton.isTrue
                ? Container(
                    color: Get.theme.cardColor,
                    padding: EdgeInsets.symmetric(
                      vertical: ctrl.responsive.hp(0),
                      horizontal: ctrl.responsive.hp(2.5),
                    ),
                    child: Video(
                      player: ctrl.player,
                      scale: 1.0, // default
                      showControls: false, // default
                    ),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
