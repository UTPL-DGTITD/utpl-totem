import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';
import 'videos_module_controller.dart';
import 'package:utpl_totem_oficial/app/data/models/tv_template_model.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

/// Página que muestra reproductor de videos de YouTube en secuencia
class VideosModulePage extends GetView<VideosModuleController> {
  final TvTemplateBody item;
  const VideosModulePage(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar controlador
    final ctrl = Get.put(
      VideosModuleController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );

    // Inicializar videos después de la construcción
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideos(ctrl);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() => _buildContent(context, ctrl)),
      ),
    );
  }

  /// Construye el contenido principal basado en el estado del controlador
  Widget _buildContent(BuildContext context, VideosModuleController ctrl) {
    if (!ctrl.isWebViewReady.value) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        _buildVideoContainer(context, ctrl),
        _buildLoadingOverlay(context, ctrl),
        _buildInteractionBlocker(),
      ],
    );
  }

  /// Construye el contenedor principal del video
  Widget _buildVideoContainer(
      BuildContext context, VideosModuleController ctrl) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      child: ClipRRect(
        child: Webview(ctrl.webviewController),
      ),
    );
  }

  /// Construye la capa de carga que se muestra durante las transiciones
  Widget _buildLoadingOverlay(
      BuildContext context, VideosModuleController ctrl) {
    return Obx(() => AnimatedOpacity(
          opacity: ctrl.isLoading.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ));
  }

  /// Construye una capa transparente que bloquea todas las interacciones
  Widget _buildInteractionBlocker() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {}, // Bloquea taps
        onPanUpdate: (_) {}, // Bloquea gestos
        child: Container(color: Colors.transparent),
      ),
    );
  }

  /// Inicializa los videos en el controlador
  void _initializeVideos(VideosModuleController ctrl) {
    ToolsHelper.logger.w('Inicializando videos del módulo');

    if (item.embeddedYoutube.isNotEmpty) {
      // Hacer copia de la lista para evitar problemas de referencia
      List<String> videosCopy = [...item.embeddedYoutube];
      ctrl.setVideosFromItem(videosCopy);
      ToolsHelper.logger
          .w('Videos cargados desde embeddedYoutube: ${videosCopy.length}');
    } else {
      // Si no hay videos, usar predeterminados
      ctrl.setVideosFromItem(['poC3PI9RM30', 'zdagGm-DrDQ', 'gyo8ee5aXF8']);
      ToolsHelper.logger.w('Usando videos predeterminados');
    }
  }
}
