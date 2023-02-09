import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/presentation/modules/youtube_videos/youtube_videos_controller.dart';
import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';

class YoutubeVideosPage extends GetView<YoutubeVideosController> {
  final TvTemplateBody item;
  const YoutubeVideosPage(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      YoutubeVideosController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );

    ctrl.initVideo(item.embeddedYoutube);
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<YoutubeVideosController>(
        init: YoutubeVideosController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
              child: ctrl.showSkeleton.isFalse
                  ? Container(
                      key: const Key("video-container"),
                      child: ctrl.loadingVideo.value == true
                          ? Container(
                              child: AspectRatio(
                                aspectRatio: ctrl
                                    .videoPlayerControllers[
                                        ctrl.counterPlayer.value]
                                    .value
                                    .aspectRatio,
                                child: VideoPlayer(
                                  ctrl.videoPlayerControllers[
                                      ctrl.counterPlayer.value],
                                ),
                              ),
                            )
                          : const Center(
                              child: SizedBox(
                                child: Text("Cargando"),
                              ),
                            ),
                    )
                  : const SkeletonList(length: 20));
        },
      ),
    );
  }
}
