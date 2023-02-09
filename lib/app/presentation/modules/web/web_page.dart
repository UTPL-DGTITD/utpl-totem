import 'package:flutter/material.dart';
import 'package:utpl_totem/app/presentation/modules/web/web_controller.dart';
import 'package:utpl_totem/app/presentation/widgets/back_arrow_button.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class WebPage extends GetView<WebController> {
  const WebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackArrowButton(),
        title: Obx(() => Text(controller.title.value)),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.url.isNotEmpty
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
        ),
      ),
    );
  }
}
