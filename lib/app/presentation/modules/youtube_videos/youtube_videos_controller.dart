import 'dart:async';

import 'package:ext_video_player/ext_video_player.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class YoutubeVideosController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  final title = 'Vídeos UTPL'.obs;

  late RxList<String> lsvideos;
  // YOUTUBE
  late RxList<VideoPlayerController> videoPlayerControllers =
      <VideoPlayerController>[].obs;

  var loadingVideo = false.obs;
  var counterPlayer = 0.obs;
  Timer videoTime = Timer(const Duration(seconds: 0), () {});

  YoutubeVideosController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
    required this.authService,
  });

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  void _initConfig() async {
    try {} catch (error, stack) {
      ToolsHelper.logger.e(
        '[youtube_videos_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  // void _loadRouteParams() {
  //   final params = Get.arguments;
  //   assert(params != null, 'Params is required');
  //   assert(params['videos'] != null, 'vides is required');
  //   assert(
  //       params['videos'] is List<String>, 'videos type is not TvTemplateModel');
  //   lsvideos.value = params['videos'];
  // }

  // youtube
  // void initVideo(TvTemplateBody item) {
  void initVideo(List<String> videos) {
    if (videoPlayerControllers.isEmpty) {
      for (var element in videos) {
        videoPlayerControllers.add(VideoPlayerController.network(
          'https://www.youtube.com/watch?v=$element',
        ));
      }
      playVideo();
    }
  }

  void playVideo() {
    try {
      if (counterPlayer.value >= videoPlayerControllers.length) {
        counterPlayer.value = 0;
      }
      if (videoPlayerControllers[counterPlayer.value].value.initialized ==
          false) {
        videoPlayerControllers[counterPlayer.value].initialize().then((_) {
          loadingVideo.value = true;
          videoPlayerControllers[counterPlayer.value].play();
          videoTime.cancel();
          videoTime = Timer(
              (videoPlayerControllers[counterPlayer.value].value.duration ??
                  1.seconds), () {
            callNewVideo();
          });
        });
      } else {
        loadingVideo.value = true;
        videoPlayerControllers[counterPlayer.value].play();
        videoTime.cancel();
        videoTime = Timer(
            (videoPlayerControllers[counterPlayer.value].value.duration ??
                1.seconds), () {
          callNewVideo();
        });
      }
    } catch (e) {
      callNewVideo();
    }
  }

  void callNewVideo() {
    videoPlayerControllers[counterPlayer.value].pause();
    videoPlayerControllers[counterPlayer.value].seekTo(Duration.zero);
    loadingVideo.value = false;
    counterPlayer.value++;
    ToolsHelper.logger.i('Video ended');
    ToolsHelper.logger.i('Listener removed');
    playVideo();
  }
}
