import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';
import 'videos_module_controller.dart';

class VideosModulePage extends StatelessWidget {
  final VideosModuleController controller = Get.put(VideosModuleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (!controller.isWebViewReady.value) {
            return const CircularProgressIndicator();
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              // Contenedor del video
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                child: ClipRRect(
                  // Pasamos el controlador como argumento posicional
                  child: Webview(controller.webviewController),
                ),
              ),

              // Capa transparente que intercepta todos los eventos de interacción
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {}, // No hace nada al hacer clic
                  onPanUpdate: (_) {}, // No hace nada al deslizar
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
