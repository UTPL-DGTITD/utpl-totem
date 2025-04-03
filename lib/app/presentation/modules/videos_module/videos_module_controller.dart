import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/videos_module/videos_config.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';
import 'dart:async';
import 'dart:convert';
import 'package:webview_windows/webview_windows.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';

class VideosModuleController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  // Lista de IDs de videos para reproducir en cadena
  final RxList<String> videoIds = <String>[].obs;

  final WebviewController webviewController = WebviewController();
  final YoutubeExplode yt = YoutubeExplode();
  final RxBool isLoading = false.obs;

  final Map<String, int> videoDurations = {};

  // Índice del video actual
  final RxInt currentVideoIndex = 0.obs;
  final RxBool isWebViewReady = false.obs;
  Timer? videoSwitchTimer;
  final RxBool isLoadingDurations = false.obs;
  DateTime? pauseTime;
  int remainingSeconds = 0;

  String get currentVideoId => videoIds.isNotEmpty
      ? videoIds[currentVideoIndex.value % videoIds.length]
      : '';

  VideosModuleController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
  });

  @override
  void onInit() async {
    super.onInit();

    // Esperar a que haya videos en la lista antes de continuar
    if (videoIds.isEmpty) {
      // Esperar hasta 2 segundos máximo
      for (int i = 0; i < 20 && videoIds.isEmpty; i++) {
        await Future.delayed(Duration(milliseconds: 100));
      }

      // Si sigue vacío después de esperar, usar ids de videos predeterminados
      if (videoIds.isEmpty) {
        videoIds.addAll(['poC3PI9RM30', 'zdagGm-DrDQ', 'gyo8ee5aXF8']);
      }
    }

    // Precarga las duraciones de los videos
    await loadNextDurations(2);
    await initPlatformState();
  }

  // Método para precargar las duraciones de los videos
  Future<void> loadNextDurations(int count) async {
    if (isLoadingDurations.value || videoIds.isEmpty) return;
    isLoadingDurations.value = true;

    int loaded = 0;
    int startIndex = currentVideoIndex.value;

    for (int i = 0; i < videoIds.length && loaded < count; i++) {
      int index = (startIndex + i) % videoIds.length;
      String videoId = videoIds[index];

      // Si ya existe la duración del video, continuar
      if (videoDurations.containsKey(videoId)) continue;

      try {
        // Obtener información del video
        final video = await yt.videos.get(videoId);

        // Guardar la duración en segundos
        videoDurations[videoId] = video.duration?.inSeconds ?? 180;

        loaded++;
      } catch (e) {
        ToolsHelper.logger
            .w('Error obteniendo duración del video $videoId: $e');
        // Duración predeterminada
        videoDurations[videoId] = 180; // 3 minutos por defecto
        loaded++;
      }
    }

    isLoadingDurations.value = false;
  }

  Future<void> initPlatformState() async {
    try {
      ToolsHelper.logger.w('🔹 Inicializando WebView Windows...');
      await webviewController.initialize();
      await webviewController.setBackgroundColor(Colors.transparent);
      await webviewController
          .setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);

      // Configurar manejador de mensajes para detectar el fin de video
      webviewController.webMessage.listen((message) {
        try {
          if (message == 'VIDEO_ENDED' || message == 'VIDEO_ALMOST_ENDED') {
            videoSwitchTimer?.cancel();
            Future.microtask(() => nextVideo());
          } else if (message == 'VIDEO_READY') {
            isLoading.value = false;
          } else {
            // Controles de video usando JSON y WebView
            try {
              final data = jsonDecode(message);
              if (data['event'] == 'VIDEO_PAUSED' &&
                  data['currentTime'] != null) {
                double currentTime = (data['currentTime'] ?? 0.0).toDouble();
                double duration = (data['duration'] ?? 0.0).toDouble();
                remainingSeconds = (duration - currentTime).round();
              }
            } catch (e) {
              // Si no es JSON válido, ignorar
            }
          }
        } catch (e) {
          ToolsHelper.logger.e('Error procesando mensaje de WebView: $e');
        }
      });

      // Cargar el primer video
      await loadCurrentVideo();

      isWebViewReady.value = true;

      // Programar cambio de videos basado en la duración estimada
      setupVideoSwitching();
    } catch (e) {
      ToolsHelper.logger.e('Error inicializando WebView: $e');
    }
  }

  //Cargar video actual
  Future<void> loadCurrentVideo() async {
    if (videoIds.isEmpty) {
      ToolsHelper.logger.w('No hay videos disponibles para cargar');
      return;
    }

    // Asegurar que el índice es válido
    if (currentVideoIndex.value >= videoIds.length) {
      currentVideoIndex.value = 0;
    }

    try {
      // Mostrar pantalla de carga
      isLoading.value = true;

      // Estilos de YouTube
      await webviewController.executeScript(youtubeStyle);

      // Url
      final String embedUrl =
          'https://www.youtube.com/embed/$currentVideoId? + $videoControls';

      await webviewController.loadUrl(embedUrl);

      await Future.delayed(const Duration(milliseconds: 800));
      await applyCustomSettings();

      // Verificar si el video está listo para reproducirse
      await webviewController.executeScript(videoReady);
    } catch (e) {
      ToolsHelper.logger.e("Error cargando video: $e");
      // Ocultar la pantalla de carga.
      isLoading.value = false;

      // Intentar recuperar cargando el siguiente video en caso de error
      Future.delayed(Duration(seconds: 2), () {
        if (isLoading.value) {
          isLoading.value = false;
          nextVideo();
        }
      });
    }
  }

  // Aplicar CSS y JavaScript para personalizar el reproductor
  Future<void> applyCustomSettings() async {
    await webviewController.executeScript(customSettings);
  }

  // Obtener el tiempo actual del video en segundos
  Future<int> getCurrentVideoTime() async {
    try {
      final result = await webviewController.executeScript(videoCurrentTime);

      return result;
    } catch (e) {
      ToolsHelper.logger.e('Error obteniendo tiempo actual del video: $e');
      return 0;
    }
  }

  // Cambio de video segun la duración del video
  Future<void> setupVideoSwitching() async {
    if (videoIds.isEmpty) return;

    // Cancelar cualquier timer existente
    videoSwitchTimer?.cancel();

    // Obtener la duración del video actual
    final int totalDuration = videoDurations[currentVideoId] ?? 180;

    try {
      // Obtener tiempo actual de reproducción
      final int currentPosition = await getCurrentVideoTime();

      // Calcular tiempo restante
      int timeRemaining = totalDuration - currentPosition;

      // Si queda poco tiempo, usar tiempo mínimo
      if (timeRemaining <= 5) {
        timeRemaining = 5;
      }

      // Ajustar 2 segundos menos para cambiar justo antes del final
      final adjustedDuration = Duration(seconds: timeRemaining - 2);

      // Programar cambio al siguiente video
      videoSwitchTimer = Timer(adjustedDuration, () {
        nextVideo();
      });
    } catch (e) {
      // Si ocurre un error, usar duración completa
      final adjustedDuration = Duration(seconds: totalDuration - 2);
      ToolsHelper.logger.w(
          '⚠️ Error obteniendo posición actual, usando duración estimada: ${adjustedDuration.inSeconds}s');

      videoSwitchTimer = Timer(adjustedDuration, () {
        nextVideo();
      });
    }

    // Cargar información del siguiente video si aún no la tenemos
    if (videoIds.length > 1) {
      int nextIndex = (currentVideoIndex.value + 1) % videoIds.length;
      String nextVideoId = videoIds[nextIndex];

      if (!videoDurations.containsKey(nextVideoId)) {
        // Cargamos en segundo plano la duración del siguiente
        loadNextDurations(1).then((_) {});
      }
    }
  }

  // Cambiar al siguiente video
  Future<void> nextVideo() async {
    if (videoIds.isEmpty) return;

    try {
      // Avanzar al siguiente video (con loop al llegar al final)
      currentVideoIndex.value = (currentVideoIndex.value + 1) % videoIds.length;

      await loadCurrentVideo();
      setupVideoSwitching();
    } catch (e) {
      ToolsHelper.logger.e('Error cambiando al siguiente video: $e');

      // Reintentar después de un breve retraso
      Future.delayed(Duration(seconds: 2), () {
        loadCurrentVideo();
        setupVideoSwitching();
      });
    }
  }

  // Método para actualizar videos desde un item
  void setVideosFromItem(List<String> videos) {
    if (videos.isNotEmpty) {
      ToolsHelper.logger
          .w('Actualizando lista de videos: ${videos.length} videos');

      // Cancelar timer existente
      videoSwitchTimer?.cancel();

      // Limpiar lista actual
      videoIds.clear();

      // Agregar nuevos videos
      videoIds.addAll([...videos]);

      // Reiniciar índice
      currentVideoIndex.value = 0;

      // Si ya se inició el WebView, reiniciar la reproducción
      if (isWebViewReady.value) {
        loadCurrentVideo();
        setupVideoSwitching();
      }
    } else {
      ToolsHelper.logger.w("⚠️ Lista de videos vacía, no se actualiza");
    }
  }

  // Método para pausar el video
  void pauseVideo() {
    try {
      ToolsHelper.logger.w('🛑 Pausando video');

      pauseTime = DateTime.now();

      // Si el WebView está listo, pausar el video
      if (isWebViewReady.value) {
        webviewController.executeScript(videoPause);
      }

      // Cancelar timer de cambio de video
      videoSwitchTimer?.cancel();
    } catch (e) {
      ToolsHelper.logger.e('Error pausando video: $e');
    }
  }

  // Método para reanudar el video
  void resumeVideo() {
    try {
      // Calcular el tiempo que el video estuvo pausado
      int pauseDuration = 0;
      if (pauseTime != null) {
        pauseDuration = DateTime.now().difference(pauseTime!).inSeconds;
      }

      // Si estuvo pausado más de 20 segundos, cambiar al siguiente video
      if (pauseDuration > 20) {
        nextVideo();
        return;
      }

      // De lo contrario, reanudar la reproducción y ajustar el timer
      if (isWebViewReady.value) {
        // Reanudar el video
        webviewController.executeScript(videoResume);

        // Reprogramar el cambio de video
        setupVideoSwitching();
      }
    } catch (e) {
      ToolsHelper.logger.e('Error reanudando video: $e');
      // En caso de error, cambiar al siguiente video
      nextVideo();
    }
  }

  @override
  void onClose() {
    ToolsHelper.logger.w("🛑 Cerrando el reproductor...");
    videoSwitchTimer?.cancel();
    webviewController.dispose();
    yt.close(); // Cerrar el cliente de YouTube
    super.onClose();
  }
}
