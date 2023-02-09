import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/presentation/modules/web_component/web_component_controller.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebComponentPage extends GetView<WebComponentController> {
  final TvTemplateBody item;
  const WebComponentPage(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      WebComponentController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );

    ctrl.loadUrl(item.link?.url ?? '');
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<WebComponentController>(
        init: WebComponentController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
            child: ctrl.url.isNotEmpty
                ? Stack(
                    children: [
                      WebView(
                        initialUrl: controller.url.value,
                        javascriptMode: JavascriptMode.unrestricted,
                        onPageFinished: (finish) =>
                            controller.isLoading.value = false,
                      ),
                      controller.isLoading.isTrue
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Stack(),
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
