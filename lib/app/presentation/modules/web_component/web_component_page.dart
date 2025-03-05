import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/web_component/web_component_controller.dart';

import 'package:webview_windows/webview_windows.dart';

class WebComponentPage extends GetView<WebComponentController> {
  //final TvTemplateBody item;
  final String item;
  const WebComponentPage(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      WebComponentController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );

    //ctrl.loadUrl(item.link?.url ?? '');
    ctrl.loadUrl(item);
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<WebComponentController>(
        tag: item,
        init: WebComponentController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
            child: controller.url.isNotEmpty
                ? Stack(
                    children: [
                      Webview(
                        controller.controllerWebView.value,
                      ),
                      controller.isLoading.isTrue
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Stack(),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      ),
    );
  }
}
