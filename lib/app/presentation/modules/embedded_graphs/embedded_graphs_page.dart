import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/embedded_graphs/embedded_graphs_controller.dart';
import 'package:utpl_totem/app/presentation/modules/web_component/web_component_page.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

class EmbeddedGraphsPage extends GetView<EmbeddedGraphsController> {
  const EmbeddedGraphsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<EmbeddedGraphsController>(
        init: EmbeddedGraphsController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return ctrl.showSkeleton.isFalse
              ? Container(
                  color: Get.theme.cardColor,
                  padding: EdgeInsets.symmetric(
                    vertical: ctrl.responsive.hp(1),
                    horizontal: ctrl.responsive.wp(1),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            color: Get.theme.cardColor,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                UtplCustom.left_small_arrow,
                                size: ctrl.responsive.ip(3),
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          onTap: () => ctrl.moveLeft(),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Stack(
                          children: [
                            Text(ctrl.title.value),
                            SizedBox(
                              width: double.maxFinite,
                              child: GestureDetector(
                                  onTap: () => null,
                                  child: Container(
                                    child: WebComponentPage(
                                        ctrl.currentUrl.value,
                                        key: UniqueKey()),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            color: Get.theme.cardColor,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                UtplCustom.right_small_arrow,
                                size: ctrl.responsive.ip(3),
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          onTap: () => ctrl.moveRight(),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox();
        },
      ),
    );
  }
}
