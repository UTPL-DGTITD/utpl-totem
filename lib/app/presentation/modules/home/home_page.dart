import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_controller.dart';
import 'package:utpl_totem/app/presentation/modules/home/utils/generate_component.dart';
import 'package:utpl_totem/app/presentation/modules/home/widgets/side_header.dart';
import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<HomeController>(
        init: HomeController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
              child: ctrl.showSkeleton.isFalse
                  ? Container(
                      // color: Colors.red,
                      width: ctrl.responsive.wp(100),
                      height: ctrl.responsive.hp(100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ctrl.responsive.wp(0.5),
                                    vertical: ctrl.responsive.hp(1),
                                  ),
                                  color: Get.theme.cardColor,
                                  width: ctrl.responsive.wp(85),
                                  height: ctrl.responsive.hp(90),
                                  child: StaggeredGrid.count(
                                    // crossAxisCount: 14,
                                    crossAxisCount: ctrl.currentTemplate.value
                                            .tvTemplateHeader?.totalColumns ??
                                        0,
                                    mainAxisSpacing: ctrl.responsive.hp(1),
                                    crossAxisSpacing: ctrl.responsive.wp(0.5),
                                    children: generateComponents(ctrl),
                                  ),
                                ),
                                Container(
                                  width: ctrl.responsive.wp(15),
                                  height: double.infinity,
                                  color: Get.theme.colorScheme.tertiary,
                                  child: SideHeader(ctrl: ctrl),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: ctrl.responsive.hp(10),
                            color: Get.theme.colorScheme.primary,
                            child: Marquee(
                              text: ctrl.loadAdvices(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.cardColor,
                                fontSize: ctrl.responsive.ip(1.8),
                              ),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              blankSpace: 20.0,
                              velocity: 50,
                              pauseAfterRound: const Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(seconds: 1),
                              accelerationCurve: Curves.linear,
                              decelerationCurve: Curves.easeOut,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SkeletonList(length: 10));
        },
      ),
    );
  }

  List<StaggeredGridTile> generateComponents(HomeController ctrl) {
    List<StaggeredGridTile> items = [];
    for (var i = 0;
        i <
            ctrl.currentTemplate.value.tvTemplateHeader!.tvTemplateBodies
                .length;
        i++) {
      var item =
          ctrl.currentTemplate.value.tvTemplateHeader!.tvTemplateBodies[i];
      items.add(
        StaggeredGridTile.count(
          crossAxisCellCount: item.totalColumns,
          mainAxisCellCount: item.totalRows,
          child: GenerateComponent.generateComponent(
              item.interaction, ctrl, item, i),
        ),
      );
    }

    return items;
  }
}
