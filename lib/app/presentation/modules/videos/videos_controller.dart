import 'dart:async';

//import 'package:dart_vlc/dart_vlc.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:utpl_totem_oficial/app/data/models/tv_template_model.dart';

import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';

import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;

class VideosController extends GetxController with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  late Timer timerVideoPlaying;
  final title = 'Vídeos UTPL'.obs;

  RxList<String> urlVideos = <String>[
    'ZBHfZLyP1SI',
    //'zdagGm-DrDQ',
    //'gyo8ee5aXF8',
    //'nNkw3Fo9Aqk',
    //'eycU0vO9Gzc',
  ].obs;
  final urlNetworkVideos = [].obs;
  final Rx<TvTemplateBody> item = TvTemplateBody().obs;

  Rx<Player> player = Player().obs;
  late final controller = VideoController(player.value);

  VideosController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
  });

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  @override
  void onClose() {
    //player.value.stop();
    player.value.dispose();
    if (timerVideoPlaying.isActive) {
      timerVideoPlaying.cancel();
    }
    super.onClose();
  }

  void _initConfig() async {
    try {
      ToolsHelper.logger.v('VIDEOS CONTROLLER $urlVideos');
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[videos_controller] (_initConfig)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  Future<List<VideoQalityUrls>?> getYoutubeVideoQualityUrls(
    String youtubeIdOrUrl,
  ) async {
    try {
      final yt = youtube.YoutubeExplode();
      final urls = <VideoQalityUrls>[];
      final manifest =
          await yt.videos.streamsClient.getManifest(youtubeIdOrUrl);
      urls.addAll(
        manifest.muxed.map(
          (element) => VideoQalityUrls(
            quality: int.parse(element.qualityLabel.split('p')[0]),
            url: element.url.toString(),
          ),
        ),
      );
      yt.close();
      return urls;
    } catch (error) {
      if (error.toString().contains('XMLHttpRequest')) {
        ToolsHelper.logger.v(
            '(INFO) To play youtube video in WEB, Please enable CORS in your browser');
      }
      ToolsHelper.logger.v('===== YOUTUBE API ERROR: $error ==========');
      rethrow;
    }
  }

  Future<void> generateUrls() async {
    //ToolsHelper.logger.v(urlVideos.length);
    urlNetworkVideos.value = [].obs;
    for (var i = 0; i < urlVideos.length; i++) {
      await getYoutubeVideoQualityUrls(
        urlVideos[i],
      ).then((value) {
        if (value != null) {
          //ToolsHelper.logger.v(value);
          VideoQalityUrls? itemToAdd =
              // Obtener unica url
              value.firstWhereOrNull(
                  (VideoQalityUrls item) => item.quality == 360);
          if (itemToAdd == null) {
            urlNetworkVideos.add(value.last.url);
          } else {
            urlNetworkVideos.add(itemToAdd.url);
          }
        }
      });
    }
    showSkeleton.value = true;
  }

  List<Media> loadNetworkVideos() {
    List<Media> medias = [];
    for (var i = 0; i < urlNetworkVideos.length; i++) {
      medias.add(Media(urlNetworkVideos[i]));
      //ToolsHelper.logger.e('URL AGREGADA: ${urlNetworkVideos[i]}');
    }
    return medias;
  }

  void playVideos() async {
    ToolsHelper.logger.v('NOW PLAYING');
    final playable = Playlist(
      loadNetworkVideos(),
    );
    showSkeleton = false.obs;
    await player.value.open(playable);
    // player.value.playbackStream.listen((PlaybackState state) {
    //   if (state.isCompleted) {
    //     player.value.play();
    //   }
    // });
    showSkeleton = true.obs;
  }

  // void validateVideo() {
  //   ToolsHelper.logger.v('VALIDAR VIDEO');
  //   if (!player.value.playback.isPlaying) {
  //     ToolsHelper.logger.v('VIDEO PAUSADO');
  //     player.value.play();
  //   }
  // }
}

class VideoQalityUrls {
  int quality;
  String url;
  VideoQalityUrls({
    required this.quality,
    required this.url,
  });

  @override
  String toString() => 'VideoQalityUrls(quality: $quality, urls: $url)';
}
