import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/observatories/observatories_controller.dart';
import 'package:utpl_totem/app/presentation/modules/observatories/observatory_detail/observatory_detail_controller.dart';
import 'package:utpl_totem/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class ObservatoryDetailPage extends GetView<ObservatoryDetailController> {
  const ObservatoryDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: controller.responsive.hp(8),
        title: Obx(
          () => Text(
            controller.title.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: controller.responsive.ip(2.5)),
          ),
        ),
        leading: const SizedBox(),
      ),
      body: GetX<ObservatoryDetailController>(
        init: ObservatoryDetailController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          var item = ctrl.observatory.value;

          return ctrl.showSkeleton.isFalse
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ctrl.responsive.wp(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ToolsHelper.htmlParser(item.name),
                              style: TextStyle(
                                fontSize: ctrl.responsive.ip(2.4),
                                color: Get.theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            customYMargin(ctrl.responsive.hp(1)),
                            SizedBox(
                              width: ctrl.responsive.wp(100),
                              //height: ctrl.responsive.hp(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: ctrl.responsive.hp(25),
                                  imageUrl: item.image,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, a, b) {
                                    return Image.asset(
                                        'assets/images/alt-image.png');
                                  },
                                  placeholder: (context, url) => Image.asset(
                                      'assets/images/alt-image.png'),
                                ),
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(1)),
                            Text(
                              ToolsHelper.htmlParser(item.description),
                              style: TextStyle(
                                fontSize: ctrl.responsive.ip(1.8),
                                color: Get.theme.colorScheme.primary,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(1)),
                            Text(
                              'Equipo',
                              style: TextStyle(
                                fontSize: ctrl.responsive.ip(2.2),
                                color: Get.theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(1)),
                            SizedBox(
                              width: ctrl.responsive.wp(100),
                              //height: ctrl.responsive.hp(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: ctrl.responsive.hp(25),
                                  imageUrl: item.equipo,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, a, b) {
                                    return Image.asset(
                                        'assets/images/alt-image.png');
                                  },
                                  placeholder: (context, url) => Image.asset(
                                      'assets/images/alt-image.png'),
                                ),
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(2)),
                            Container(
                              height: ctrl.responsive.hp(33),
                              width: double.infinity,
                              child: ListView.separated(
                                controller: ctrl.scrollController,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) => SizedBox(
                                  width: ctrl.responsive.wp(2.5),
                                ),
                                itemCount: item.members.length,
                                itemBuilder: (context, index) {
                                  var member = item.members[index];
                                  return InkWell(
                                    onTap: () => null,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ctrl.responsive.wp(1),
                                        vertical: ctrl.responsive.hp(1),
                                      ),
                                      width: ctrl.responsive.wp(35),
                                      color: Get.theme.cardColor,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: ctrl.responsive.hp(6),
                                            child: Text(
                                              member.name,
                                              style: TextStyle(
                                                fontSize:
                                                    ctrl.responsive.ip(1.8),
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            ),
                                          ),
                                          SizedBox(
                                            width: ctrl.responsive.wp(100),
                                            height: ctrl.responsive.hp(15),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                height: ctrl.responsive.hp(5),
                                                imageUrl: member.image,
                                                fit: BoxFit.contain,
                                                errorWidget: (context, a, b) {
                                                  return Image.asset(
                                                      'assets/images/alt-image.png');
                                                },
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                        'assets/images/alt-image.png'),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: ctrl.responsive.hp(9),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  member.type,
                                                  style: TextStyle(
                                                    fontSize:
                                                        ctrl.responsive.ip(1.7),
                                                    color: Get.theme.colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      UtplCustom
                                                          .alternate_email,
                                                      size: ctrl.responsive
                                                          .ip(1.3),
                                                    ),
                                                    Text(
                                                      ' ${ctrl.getUserSplitEmail(member.email)}',
                                                      style: TextStyle(
                                                        fontSize: ctrl
                                                            .responsive
                                                            .ip(1.6),
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: ctrl.responsive.hp(1),
                                            thickness: ctrl.responsive.hp(0.8),
                                            color:
                                                Get.theme.colorScheme.tertiary,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(5)),
                          ],
                        ),
                      ),
                      Container(
                        color: Get.theme.colorScheme.primary,
                        width: double.infinity,
                        height: ctrl.responsive.hp(7),
                        child: Center(
                          child: Text(
                            'DGTI - powered by UTPL+',
                            style: TextStyle(
                              fontSize: ctrl.responsive.ip(2),
                              color: Get.theme.cardColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const SkeletonList(length: 20);
        },
      ),
    );
  }
}
