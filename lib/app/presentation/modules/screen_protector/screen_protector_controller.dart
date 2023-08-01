import 'dart:async';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/flicker_video_img_responde_model.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

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
  Rx<Player> player = Player(id: 69421).obs;

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
    player.value.dispose();
    // player.value.stop();
    super.onClose();
  }

  void _initConfig() async {
    try {
      _loadRouteParams();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[screen_protector_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void exitScreenProtector() {
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

  void playVideos() {
    ToolsHelper.logger.v('NOW PLAYING');
    //showSkeleton = false.obs;
    player.value.open(
      Playlist(medias: loadNetworkVideos()),
      autoStart: true,
    );
    player.value.playbackStream.listen((PlaybackState state) {
      if (state.isCompleted) {
        player.value.play();
      }
    });
    //showSkeleton = true.obs;
  }

  List<Media> loadNetworkVideos() {
    List<Media> medias = [];
    medias.add(
      Media.network(
        flickerItem.value.source,
      ),
    );
    return medias;
  }

  void validateVideo() {
    ToolsHelper.logger.v('VALIDAR VIDEO');
    if (!player.value.playback.isPlaying) {
      ToolsHelper.logger.v('VIDEO PAUSADO');
      player.value.play();
    }
  }

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
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }
}
