import 'dart:async';

//import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:utpl_totem_oficial/app/data/models/flicker_video_img_responde_model.dart';
import 'package:utpl_totem_oficial/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

class ScreenProtectorController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  RxString title = 'Protector de Pantalla'.obs;
  Rx<GenericListItemModel> wallpaper = GenericListItemModel().obs;
  Color colorContent = const Color(0xFFCACACA);
  Rx<Player> player = Player().obs;
  late final controller = VideoController(player.value);

  ScreenProtectorController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
  });

  Timer timerVideoPlaying =
      Timer.periodic(const Duration(minutes: 1), (timer) async {});
  Rx<FlickerVideoImgResponseModel> flickerItem =
      FlickerVideoImgResponseModel().obs;
  RxString idVideo = ''.obs;
  RxBool controllerVideo = false.obs;

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  @override
  void onClose() {
    ToolsHelper.logger.v('CERRAR VIDEOS');
    timerVideoPlaying.isActive ? timerVideoPlaying.cancel() : null;
    //player.value.currentController.done;
    //MEDIA KIT

    player.value.stop();
    //player.value.dispose();
    controllerVideo.close();

    super.onClose();
  }

  void _initConfig() async {
    try {
      _loadRouteParams();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[screen_protector_controller] (_initConfig)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void exitScreenProtector() {
    player.value.stop();
    Get.back();
  }

  void _loadRouteParams() {
    final params = Get.arguments;
    assert(params != null, 'Params is required');
    assert(params['wallpaper'] != null, 'wallpaper is required');
    assert(params['wallpaper'] is GenericListItemModel,
        'wallpaper is not type GenericListItemModel');
    wallpaper.value = params['wallpaper'];
  }

  // void playVideos() {
  //   ToolsHelper.logger.v('NOW PLAYING');
  //   player.value.open(
  //     Playlist(medias: loadNetworkVideos()),
  //     autoStart: true,
  //   );
  //   player.value.playbackStream.listen((PlaybackState state) {
  //     if (state.isCompleted) {
  //       player.value.play();
  //     }
  //   });
  // }

  void playVideos() async {
    ToolsHelper.logger.v('NOW PLAYING');
    player.value.open(
      Media(flickerItem.value.source ?? ''),
    );
    await player.value.setPlaylistMode(PlaylistMode.loop);
  }

  // List<Media> loadNetworkVideos() {
  //   List<Media> medias = [];
  //   medias.add(
  //     Media.network(
  //       flickerItem.value.source,
  //     ),
  //   );
  //   return medias;
  // }

  // void validateVideo() {
  //   ToolsHelper.logger.v('VALIDAR VIDEO');
  //   if (!player.value.playback.isPlaying) {
  //     ToolsHelper.logger.v('VIDEO PAUSADO');
  //     player.value.play();
  //   }
  // }

  Future<void> loadFlickerVideo(String id) async {
    try {
      var result = await apiRepository.getFlickerVideoImage(
        id: id,
        media: 'video',
        quality: '1080p',
      );
      switch (result.status) {
        case 200:
          flickerItem.value =
              FlickerVideoImgResponseModel.fromJson(result.data);
          controllerVideo.value = true;
          update();
          break;
        default:
          controllerVideo.value = false;
          ToolsHelper.logger.i("Not results found");
      }
    } on TimeoutException {
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[screen_protector_controller] (loadFlickerVideo)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }
}
