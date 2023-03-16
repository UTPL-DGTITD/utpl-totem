import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:utpl_totem/app/presentation/modules/ranking/ranking_controller.dart';
import 'package:utpl_totem/app/presentation/modules/ranking/widgets/carrousel_slider_ranking.dart';
import 'package:utpl_totem/app/presentation/modules/ranking/widgets/modal_dialog_ranking.dart';
import 'package:utpl_totem/app/presentation/widgets/empty_results_widget.dart';

import 'package:utpl_totem/app/themes/metro_ui_icons.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

class RankingPage extends GetView<RankingController> {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<RankingController>(
        init: RankingController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return ctrl.showSkeleton.isFalse
              ? ctrl.hasRanking.isTrue
                  ? Container(
                      color: Get.theme.cardColor,
                      child: Column(
                        children: [
                          Expanded(
                            child: Text(
                              'Ranking Internacional UTPL',
                              style: Get.textTheme.headline6?.copyWith(
                                fontSize: ctrl.responsive.ip(1.6),
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CarrouselSliderRanking(ctrl: ctrl),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () =>
                                        ModalDialogRanking.alertRanking(
                                      context,
                                      ctrl.selectedRanking.value,
                                      ctrl,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ctrl.selectedRanking.value.title,
                                          style:
                                              Get.textTheme.headline6?.copyWith(
                                            fontSize: ctrl.responsive.ip(1.6),
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Get.theme.colorScheme.primary,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                        Container(
                                          color: Get.theme.cardColor,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ctrl.responsive.wp(2),
                                            vertical: ctrl.responsive.hp(0.5),
                                          ),
                                          width: double.maxFinite,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    ctrl.responsive.hp(1.5)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Ver más',
                                                      style: Get
                                                          .textTheme.headline6
                                                          ?.copyWith(
                                                        fontSize: ctrl
                                                            .responsive
                                                            .ip(1.5),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                    Icon(
                                                      UtplCustom
                                                          .right_small_arrow,
                                                      color: Get.theme
                                                          .colorScheme.primary,
                                                      size:
                                                          ctrl.responsive.ip(2),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: EmptyResultsWidget(
                        assetPath:
                            'assets/images/story-set/story-set-login.png',
                        description: "No existen rankings actualmente",
                        btnText: "Volver",
                        onTap: () => Get.back(),
                      ),
                    )
              : const SizedBox();
        },
      ),
    );
  }
}
