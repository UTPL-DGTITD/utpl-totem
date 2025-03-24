import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';
import 'dart:async';
import 'package:webview_windows/webview_windows.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:utpl_totem_oficial/app/data/models/tv_template_model.dart';
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

  // Getter seguro para el ID actual
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
    print("🔹 Inicializando el reproductor WebView...");

    // Esperar a que haya videos antes de continuar
    if (videoIds.isEmpty) {
      print("⏳ Esperando a que se asignen los videos...");

      // Esperar hasta 2 segundos máximo
      for (int i = 0; i < 20 && videoIds.isEmpty; i++) {
        await Future.delayed(Duration(milliseconds: 100));
      }

      // Si sigue vacío después de esperar, usar predeterminados
      if (videoIds.isEmpty) {
        print("⚠️ No se recibieron videos, usando predeterminados");
        videoIds.addAll(['poC3PI9RM30', 'zdagGm-DrDQ', 'gyo8ee5aXF8']);
      }
    }

    print("✅ Videos disponibles: ${videoIds.length}");

    // Precarga las duraciones de los videos
    await loadNextDurations(2);
    await initPlatformState();
  }

  // Método para precargar las duraciones de los videos
  Future<void> loadNextDurations(int count) async {
    if (isLoadingDurations.value || videoIds.isEmpty) return;
    isLoadingDurations.value = true;

    print("📊 Obteniendo duración para los próximos $count videos");

    int loaded = 0;
    int startIndex = currentVideoIndex.value;

    for (int i = 0; i < videoIds.length && loaded < count; i++) {
      int index = (startIndex + i) % videoIds.length;
      String videoId = videoIds[index];

      // Si ya tenemos la duración, saltamos
      if (videoDurations.containsKey(videoId)) continue;

      try {
        // Obtener información del video
        final video = await yt.videos.get(videoId);

        // Guardar la duración en segundos
        videoDurations[videoId] = video.duration?.inSeconds ?? 180;

        print("ℹ️ Video $videoId: ${videoDurations[videoId]} segundos");
        loaded++;
      } catch (e) {
        print("⚠️ Error obteniendo duración del video $videoId: $e");
        // Si hay error, establecer una duración predeterminada
        videoDurations[videoId] = 180; // 3 minutos por defecto
        loaded++;
      }
    }

    isLoadingDurations.value = false;
  }

  Future<void> initPlatformState() async {
    try {
      await webviewController.initialize();
      await webviewController.setBackgroundColor(Colors.transparent);
      await webviewController
          .setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);

      // Cargar el primer video
      await loadCurrentVideo();

      isWebViewReady.value = true;
      print(
          "✅ WebView listo, reproduciendo video ${currentVideoIndex.value + 1} de ${videoIds.length}");

      // Programar cambio de videos basado en la duración estimada
      setupVideoSwitching();
    } catch (e) {
      print("❌ Error inicializando WebView: $e");
    }
  }

  // Método para cargar el video actual de manera segura
  Future<void> loadCurrentVideo() async {
    if (videoIds.isEmpty) {
      print("⚠️ No hay videos disponibles para cargar");
      return;
    }

    // Asegurar que el índice es válido
    if (currentVideoIndex.value >= videoIds.length) {
      currentVideoIndex.value = 0;
    }

    print("🎬 Cargando video: $currentVideoId");

    try {
      // Mostrar pantalla de carga
      isLoading.value = true;

      // 1. PRIMERO aplicamos estilos generales que preparan el contenedor
      await webviewController.executeScript('''
        (function() {
          // Crear estilos de preparación
          var prepStyle = document.createElement('style');
          prepStyle.id = 'youtube-prep-style';
          prepStyle.textContent = `
            body, html, * {
              background-color: black !important;
              margin: 0 !important;
              padding: 0 !important;
              overflow: hidden !important;
            }
          `;
          document.head.appendChild(prepStyle);
        })();
      ''');

      // 2. Construir la URL de YouTube con parámetros óptimos
      final String embedUrl = 'https://www.youtube.com/embed/$currentVideoId?' +
          'controls=0&' + // Sin controles de reproducción
          'autoplay=1&' + // Inicia automáticamente
          'mute=1&' + // Video silenciado
          'rel=0&' + // Sin videos relacionados
          'showinfo=0&' + // Sin información del video
          'modestbranding=1&' + // Mínimo branding de YouTube
          'iv_load_policy=3&' + // Sin anotaciones
          'disablekb=1&' + // Deshabilita controles de teclado
          'fs=0&' + // Deshabilita botón de pantalla completa
          'playsinline=1&' + // Reproducir dentro del elemento
          'enablejsapi=1'; // Habilita JavaScript API

      // 3. Cargar el video (mantenemos la pantalla de carga)
      await webviewController.loadUrl(embedUrl);

      await Future.delayed(const Duration(milliseconds: 800));
      await applyCustomSettings();

      // Verificar si el video está listo para reproducirse
      await webviewController.executeScript('''
        (function() {
          var video = document.querySelector('video');
          if (video) {
            video.muted = true;
            video.play();
            window.chrome.webview.postMessage('VIDEO_READY');
          } else {
            window.chrome.webview.postMessage('VIDEO_NOT_READY');
          }
        })();
      ''');

      // 7. Ocultar la pantalla de carga después de que todo esté listo
      isLoading.value = false;

      print("✅ Video $currentVideoId cargado y adaptado completamente");
    } catch (e) {
      print("❌ Error cargando video: $e");
      // Asegurarnos de ocultar la pantalla de carga incluso si hay error
      isLoading.value = false;
    }
  }

  // Aplicar CSS y JavaScript para personalizar el reproductor
  Future<void> applyCustomSettings() async {
    await webviewController.executeScript('''
    (function() {
      // Eliminar cualquier estilo previo para evitar duplicados
      var oldStyle = document.getElementById('youtube-custom-style');
      if (oldStyle) {
        oldStyle.parentNode.removeChild(oldStyle);
      }
      
      // Crear un nuevo estilo con ID para poder referenciarlo después
      var style = document.createElement('style');
      style.id = 'youtube-custom-style';
      style.textContent = `
        /* Ocultar logo de YouTube y otros elementos de la UI */
        .ytp-chrome-top,
        .ytp-chrome-bottom,
        .ytp-watermark,
        .ytp-youtube-button,
        .ytp-embed-title,
        .ytp-impression-link,
        .ytp-pause-overlay,
        .ytp-gradient-top,
        .ytp-gradient-bottom,
        .ytp-spinner,
        .ytp-thumbnail-overlay,
        .ytp-large-play-button,
        .ytp-mute-button,
        .ytp-volume-panel,
        .ytp-volume-slider-handle,
        .ytp-scrubber-container,
        .ytp-progress-bar-container,
        .ytp-time-display,
        .ytp-chapter-container,
        .ytp-menuitem,
        .ytp-ce-element,
        .ytp-ce-video,
        .ytp-ce-element-shadow,
        .ytp-watch-later-button,
        .ytp-share-button,
        .ytp-subtitles-button,
        .ytp-settings-button,
        .ytp-playlist-menu-button,
        .ytp-autonav-endscreen-countdown-container {
          display: none !important;
          opacity: 0 !important;
          pointer-events: none !important;
          visibility: hidden !important;
        }
        
        /* Configuración para que todo ocupe el 100% del espacio */
        iframe, 
        body, 
        html, 
        #player, 
        .html5-video-player, 
        .html5-video-container,
        video {
          width: 100% !important;
          height: 100% !important;
          margin: 0 !important;
          padding: 0 !important;
          overflow: hidden !important;
          object-fit: cover !important;
          background-color: black !important;
        }
        
        /* Forzar el video a ocupar todo el espacio disponible */
        video {
          position: absolute !important;
          top: 0 !important;
          left: 0 !important;
          right: 0 !important;
          bottom: 0 !important;
          object-fit: fill !important;
          min-width: 100% !important;
          min-height: 100% !important;
          transform: none !important;
        }
        
        /* Evitar barras de desplazamiento */
        ::-webkit-scrollbar {
          display: none !important;
          width: 0 !important;
          height: 0 !important;
        }
      `;
      
      document.head.appendChild(style);
      
      // Ajustar manualmente el tamaño de todos los elementos relevantes
      function resizeElements() {
        // Obtener todos los contenedores y elementos relevantes
        const containers = [
          document.querySelector('.html5-video-container'),
          document.querySelector('.html5-video-player'),
          document.querySelector('#player'),
          document.querySelector('video')
        ];
        
        // Establecer tamaño al 100% para cada elemento
        containers.forEach(element => {
          if (element) {
            element.style.width = '100%';
            element.style.height = '100%';
            element.style.position = 'absolute';
            element.style.top = '0';
            element.style.left = '0';
            element.style.objectFit = 'fill';
          }
        });
        
        // Establecer específicamente para el video
        const video = document.querySelector('video');
        if (video) {
          video.muted = true;
          video.play();
          video.style.objectFit = 'fill';
        }
      }
      
      // Ejecutar ahora y periódicamente
      resizeElements();
      setInterval(resizeElements, 1000);
      
      // Prevenir cualquier interacción
      document.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        return false;
      }, true);
      
      // Prevenir menú contextual
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        return false;
      }, true);
    })();
  ''');
  }

  // Configurar el cambio de video basado en la duración real
  Future<void> setupVideoSwitching() async {
    if (videoIds.isEmpty) return;

    // Cancelar cualquier timer existente
    videoSwitchTimer?.cancel();

    // Obtener la duración del video actual
    final int durationInSeconds = videoDurations[currentVideoId] ?? 180;

    // Ajustar unos segundos menos para cambiar justo antes del final
    final adjustedDuration = Duration(seconds: durationInSeconds - 2);

    print("⏱️ Programando cambio de video en $adjustedDuration");

    // Programar cambio al siguiente video
    videoSwitchTimer = Timer(adjustedDuration, () {
      nextVideo();
    });

    // Cargar información del siguiente video si aún no la tenemos
    // (esto se hace en segundo plano mientras se reproduce el actual)
    if (videoIds.length > 1) {
      int nextIndex = (currentVideoIndex.value + 1) % videoIds.length;
      String nextVideoId = videoIds[nextIndex];

      if (!videoDurations.containsKey(nextVideoId)) {
        // Cargamos en segundo plano la duración del siguiente
        loadNextDurations(1).then((_) {
          print("✓ Información del siguiente video precargada");
        });
      }
    }
  }

  // Cambiar al siguiente video
  Future<void> nextVideo() async {
    if (videoIds.isEmpty) return;

    // Avanzar al siguiente video (con loop al llegar al final)
    currentVideoIndex.value = (currentVideoIndex.value + 1) % videoIds.length;
    print(
        "🔄 Cambiando al video ${currentVideoIndex.value + 1} de ${videoIds.length}");

    await loadCurrentVideo();
    setupVideoSwitching();
  }

  // Método para actualizar videos desde un item
  void setVideosFromItem(List<String> videos) {
    if (videos.isNotEmpty) {
      // Limpiar lista actual
      videoIds.clear();

      // Agregar nuevos videos
      videoIds.addAll([...videos]);

      // Reiniciar índice
      currentVideoIndex.value = 0;

      print("✅ Lista de videos actualizada: ${videoIds.length} videos");

      // Si ya se inició el WebView, reiniciar la reproducción
      if (isWebViewReady.value) {
        loadCurrentVideo();
        setupVideoSwitching();
      }
    } else {
      print("⚠️ Lista de videos vacía, no se actualiza");
    }
  }

  @override
  void onClose() {
    print("🛑 Cerrando el reproductor...");
    videoSwitchTimer?.cancel();
    webviewController.dispose();
    yt.close(); // Importante cerrar el cliente de YouTube
    super.onClose();
  }
}
