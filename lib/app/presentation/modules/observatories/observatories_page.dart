import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/end_point_base_model.dart';
import 'package:utpl_totem/app/presentation/modules/observatories/observatories_controller.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

class ObservatoriesPage extends GetView<ObservatoriesController> {
  const ObservatoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<ObservatoriesController>(
        init: ObservatoriesController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return ctrl.showSkeleton.isFalse
              ? Row(
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
                      child: Container(
                        color: Get.theme.cardColor,
                        width: double.infinity,
                        // height: (responsive.width / 2) + responsive.hp(0.2),
                        child: GridView.builder(
                          controller: ctrl.scrollController,
                          //physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: ctrl.observatories.length,
                          shrinkWrap: true,
                          //itemExtent: ctrl.responsive.wp(18),

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: ctrl.responsive.hp(2),
                            mainAxisSpacing: ctrl.responsive.wp(0),
                            childAspectRatio: 1 / 1,
                            crossAxisCount: 1,
                          ),
                          itemBuilder: (context, index) {
                            //var item = sections[index];

                            return InkWell(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: (ctrl.responsive.width / 4) -
                                        ctrl.responsive.wp(13),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          ctrl.responsive.ip(1.5)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            ctrl.responsive.hp(1.6)),
                                        color: Get.theme.colorScheme.tertiary,
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: SvgPicture.network(
                                          //height: ctrl.responsive.hp(2),
                                          ctrl.observatories[index].image
                                                  ?.url ??
                                              "",
                                          fit: BoxFit.contain,
                                          width: ctrl.responsive.ip(6),
                                          color:
                                              Get.theme.colorScheme.onTertiary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  customYMargin(ctrl.responsive.hp(0.6)),
                                  // \u00ad
                                  Expanded(
                                    child: Text(
                                      'Observatorio\n${ctrl.observatories[index].acronym}'
                                          .replaceAll("-", "\u00ad"),
                                      style: Get.textTheme.bodyText1?.copyWith(
                                        fontSize: ctrl.responsive.ip(1.2),
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.2,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => ctrl
                                  .navigateToDetail(ctrl.observatories[index]),
                            );
                          },
                        ),
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
                )
              : SizedBox();
        },
      ),
    );
  }
}
