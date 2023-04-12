import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';

import 'package:utpl_totem/app/presentation/modules/home/home_controller.dart';
import 'package:utpl_totem/app/presentation/modules/home/utils/generate_component.dart';
import 'package:utpl_totem/app/presentation/modules/home/widgets/side_header.dart';
import 'package:utpl_totem/app/presentation/modules/videos/videos_page.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TvTemplateModel item = tvTemplateModelFromJson('');

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
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) {
              ToolsHelper.logger.v('USUARIO: onTapDown');
              ctrl.resetTimer();
            },
            onPanDown: (_) {
              ToolsHelper.logger.v('USUARIO: onPanDown');
              ctrl.resetTimer();
            },
            onTap: () {
              ToolsHelper.logger.v('USUARIO: onTap');
              ctrl.resetTimer();
            },
            child: SafeArea(
              child: ctrl.showSkeleton.isFalse
                  ? Container(
                      color: Get.theme.cardColor,
                      width: ctrl.responsive.wp(100),
                      height: ctrl.responsive.hp(100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  height: ctrl.responsive.hp(91),
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Get.theme.cardColor,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ctrl.responsive.wp(4),
                                        ),
                                        child: InkWell(
                                          onTap: () => ctrl.refreshTemplate(),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'UTPL',
                                                style: TextStyle(
                                                  fontSize:
                                                      ctrl.responsive.ip(4),
                                                  color: Get.theme.colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '+',
                                                style: TextStyle(
                                                  fontSize:
                                                      ctrl.responsive.ip(4),
                                                  color: Get.theme.colorScheme
                                                      .tertiary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      customYMargin(ctrl.responsive.hp(0.5)),
                                      Expanded(
                                        child: StaggeredGrid.count(
                                          // crossAxisCount: 14,
                                          crossAxisCount: 10,
                                          axisDirection: AxisDirection.down,
                                          mainAxisSpacing:
                                              ctrl.responsive.hp(1),
                                          crossAxisSpacing:
                                              ctrl.responsive.wp(0.5),
                                          children:
                                              //
                                              generateComponents(ctrl),
                                          //generateStaticComponents(ctrl),
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
                            height: ctrl.responsive.hp(9),
                            color: Get.theme.colorScheme.primary,
                            child: Container(
                              // margin: EdgeInsets.symmetric(
                              //   vertical: ctrl.responsive.hp(2),
                              // ),
                              color: ctrl.colorNotify.value,
                              child: Marquee(
                                text: ctrl.notify.value,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ctrl.colorTextNotify.value,
                                  fontSize: ctrl.responsive.ip(1.8),
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                blankSpace: 20.0,
                                velocity: 50,
                                pauseAfterRound: const Duration(seconds: 0),
                                startPadding: 10.0,
                                accelerationDuration:
                                    const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          );
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

  List<StaggeredGridTile> generateStaticComponents(HomeController ctrl) {
    List<StaggeredGridTile> items = [];
    items.add(
      // INDICADORES
      // StaggeredGridTile.count(
      //   crossAxisCellCount: 10,
      //   mainAxisCellCount: 3,
      //   child: Container(
      //     color: Get.theme.cardColor,
      //     child:
      //         const ObservatoriesPage(),
      //   ),
      // ),
      StaggeredGridTile.count(
        crossAxisCellCount: 10,
        mainAxisCellCount: 5,
        child: Container(
          color: Get.theme.cardColor,
          child: VideosPage(TvTemplateBody()),
        ),
      ),
      // StaggeredGridTile.count(
      //   crossAxisCellCount: 10,
      //   mainAxisCellCount: 3,
      //   child: Container(
      //     color: Get.theme.cardColor,
      //     child: const BannerPage(),
      //   ),
      // ),

      // StaggeredGridTile.count(
      //   crossAxisCellCount: 10,
      //   mainAxisCellCount: 5,
      //   child: Container(
      //     color: Get.theme.cardColor,
      //     child:
      //         const InvestigationPage(),
      //   ),
      // ),

      // StaggeredGridTile.count(
      //   crossAxisCellCount: 10,
      //   mainAxisCellCount: 4,
      //   child: Container(
      //     color: Get.theme.cardColor,
      //     child: const RankingPage(),
      //   ),
      // ),
      //],
    );

    return items;
  }
}
