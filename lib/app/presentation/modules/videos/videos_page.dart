//import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:utpl_totem_oficial/app/data/models/tv_template_model.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/videos/videos_controller.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

class VideosPage extends GetView<VideosController> {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final ctrl = Get.put(
    //   VideosController(
    //     localRepository: Get.find(),
    //     apiRepository: Get.find(),
    //     toastService: Get.find(),
    //   ),
    // );
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
        ),
        initState: (ctrl) async {
          ToolsHelper.logger.v('es el 1: ZBHfZLyP1SI');
          // ctrl.controller!.urlVideos.value = item.embeddedYoutube;
          ctrl.controller!.urlVideos.value = ['ZBHfZLyP1SI'];
          ctrl.controller!.player.value.play();
          ctrl.controller!.urlVideos.value = ['ZBHfZLyP1SI'];
          await ctrl.controller!.generateUrls();
          ctrl.controller!.playVideos();
          // ctrl.controller!.timerVideoPlaying =
          //     Timer.periodic(const Duration(minutes: 1), (timer) async {
          //   ctrl.controller!.validateVideo();
          // });
        },
        builder: (ctrl) {
          return SafeArea(
            child: ctrl.showSkeleton.isTrue
                ? Container(
                    color: Color.fromARGB(255, 230, 227, 35),
                    padding: EdgeInsets.symmetric(
                      vertical: ctrl.responsive.hp(0),
                      horizontal: ctrl.responsive.hp(2.5),
                    ),
                    child: Video(
                      controller: ctrl.controller,
                      fit: BoxFit.contain,
                      wakelock: true,
                      controls: (state) => SizedBox(),
                      fill: Colors.transparent,
                    ),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
