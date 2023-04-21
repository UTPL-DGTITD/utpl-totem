import 'package:flutter/material.dart';
import 'package:utpl_totem/app/presentation/modules/web/web_controller.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:webview_windows/webview_windows.dart';

class WebPage extends GetView<WebController> {
  const WebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: const FloatBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: responsive.hp(8),
        title: Obx(
          () => Text(
            controller.title.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: responsive.ip(2.5)),
          ),
        ),
        leading: const SizedBox(),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.url.isNotEmpty
              ? Stack(
                  children: [
                    Webview(
                      controller.controllerWebView.value,
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
