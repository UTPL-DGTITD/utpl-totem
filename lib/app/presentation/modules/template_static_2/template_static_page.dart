import 'package:ext_video_player/ext_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:rive/rive.dart';
import 'package:utpl_totem/app/presentation/modules/banner/banner_page.dart';
import 'package:utpl_totem/app/presentation/modules/events/events_page.dart';
import 'package:utpl_totem/app/presentation/modules/news/new_page.dart';

import 'package:utpl_totem/app/presentation/modules/template_static_2/template_static_controller.dart';
import 'package:utpl_totem/app/presentation/modules/template_static_2/widgets/side_header.dart';
import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';

class TemplateStaticPage2 extends GetView<TemplateStaticController2> {
  const TemplateStaticPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<TemplateStaticController2>(
        init: TemplateStaticController2(
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
                                  width: ctrl.responsive.wp(75),
                                  height: ctrl.responsive.hp(90),
                                  child: StaggeredGrid.count(
                                    // crossAxisCount: 14,
                                    crossAxisCount: 10,
                                    axisDirection: AxisDirection.down,
                                    mainAxisSpacing: ctrl.responsive.hp(1),
                                    crossAxisSpacing: ctrl.responsive.wp(0.5),
                                    children: [
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 5,
                                        mainAxisCellCount: 2,
                                        child: Container(
                                          color: Get.theme.cardColor,
                                          child: Center(
                                            child: Text(
                                              'UTPL+',
                                              style: TextStyle(
                                                fontSize:
                                                    ctrl.responsive.ip(4.5),
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 5,
                                        mainAxisCellCount: 2,
                                        child: Container(
                                          color: Get.theme.cardColor,
                                          child: SizedBox(
                                            child: Image.asset(
                                                'assets/images/smartland.png',
                                                scale: 0.65),
                                          ),
                                        ),
                                      ),
                                      // StaggeredGridTile.count(
                                      //   crossAxisCellCount: 10,
                                      //   mainAxisCellCount: 6,
                                      //   child: Obx(
                                      //     () => Container(
                                      //       key: const Key("video-container"),
                                      //       child: ctrl.controllerVideo.value
                                      //           ? AspectRatio(
                                      //               aspectRatio: ctrl
                                      //                   .controller
                                      //                   .value
                                      //                   .value
                                      //                   .aspectRatio,
                                      //               child: VideoPlayer(
                                      //                   ctrl.controller.value),
                                      //             )
                                      //           : const Center(
                                      //               child: Text('Cargando'),
                                      //             ),
                                      //     ),
                                      //   ),
                                      // ),

                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 10,
                                        mainAxisCellCount: 6,
                                        child: Container(
                                          color: Get.theme.cardColor,
                                          child: const NewsPage(),
                                        ),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 10,
                                        mainAxisCellCount: 6,
                                        child: Container(
                                          color: Get.theme.cardColor,
                                          child: const EventsPage(),
                                        ),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 10,
                                        mainAxisCellCount: 2.5,
                                        child: Container(
                                          color: Get.theme.cardColor,
                                          child: const BannerPage(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: ctrl.responsive.wp(25),
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
                              text: ctrl.advices.value,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.cardColor,
                                fontSize: ctrl.responsive.ip(1.8),
                              ),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              blankSpace: 20.0,
                              velocity: 50,
                              pauseAfterRound: const Duration(seconds: 0),
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

  // List<StaggeredGridTile> generateComponents(TemplateStaticController ctrl) {
  //   List<StaggeredGridTile> items = [];
  //   items.add(
  //     StaggeredGridTile.count(
  //         crossAxisCellCount: 10,
  //         mainAxisCellCount: 6,
  //         // child: Container()
  //         child: Obx(() => Container(
  //               child: ctrl.controller.value.value.initialized
  //                   ? AspectRatio(
  //                       aspectRatio: ctrl.controller.value.value.aspectRatio,
  //                       child: VideoPlayer(ctrl.controller.value),
  //                     )
  //                   : const Center(child: Text('Cargando')),
  //             ))),
  //   );

  //   return items;
  // }
}
