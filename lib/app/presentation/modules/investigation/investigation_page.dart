import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:utpl_totem_oficial/app/presentation/modules/investigation/investigation_controller.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';

class InvestigationPage extends GetView<InvestigationController> {
  const InvestigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<InvestigationController>(
        init: InvestigationController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
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
                        child: Container(
                          width: double.infinity,
                          color: Get.theme.cardColor,
                          child: ListView.separated(
                            controller: ctrl.scrollController,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //   //mainAxisExtent: 10,
                            //   crossAxisSpacing: ctrl.responsive.hp(2.2),
                            //   mainAxisSpacing: ctrl.responsive.wp(3),
                            //   childAspectRatio: 1 / 1,
                            //   crossAxisCount: 1,
                            // ),

                            separatorBuilder: (context, index) => SizedBox(
                              width: ctrl.responsive.wp(1),
                            ),

                            itemCount: ctrl.investigations.length,
                            itemBuilder: (context, index) => InkWell(
                              //onTap: () => null,
                              child: Container(
                                width: ctrl.responsive.wp(20),
                                color: Get.theme.cardColor,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: ctrl.responsive.wp(12),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ctrl.responsive.wp(0),
                                          vertical: ctrl.responsive.hp(0),
                                        ),
                                        child: SvgPicture.network(
                                          height: ctrl.responsive.hp(5),
                                          ctrl.investigations[index].image
                                                  ?.url ??
                                              "",
                                          fit: BoxFit.contain,
                                          colorFilter: ColorFilter.mode(
                                            Get.theme.colorScheme.primary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              ctrl.investigations[index].value
                                                  .toString(),
                                              style: Get.textTheme.bodyLarge
                                                  ?.copyWith(
                                                fontSize:
                                                    ctrl.responsive.ip(1.6),
                                                fontWeight: FontWeight.bold,
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                letterSpacing: 0.2,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(
                                            child: Text(
                                              ctrl.investigations[index].title
                                                  .replaceAll("-", "\u00ad"),
                                              style: Get.textTheme.bodyLarge
                                                  ?.copyWith(
                                                fontSize:
                                                    ctrl.responsive.ip(1.4),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
