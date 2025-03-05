import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/observatories/observatory_detail/observatory_detail_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/footer_utpl.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/skeleton_list.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

class ObservatoryDetailPage extends GetView<ObservatoryDetailController> {
  const ObservatoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // appBar: AppBar(
      //   centerTitle: true,
      //   toolbarHeight: controller.responsive.hp(8),
      //   title: Obx(
      //     () => Text(
      //       controller.title.value,
      //       textAlign: TextAlign.center,
      //       style: TextStyle(fontSize: controller.responsive.ip(2.5)),
      //     ),
      //   ),
      //   leading: const SizedBox(),
      // ),
      body: GetX<ObservatoryDetailController>(
        init: ObservatoryDetailController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          var item = ctrl.observatory.value;

          return ctrl.showSkeleton.isFalse
              ? Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: ctrl.responsive.hp(2)),
                      height: ctrl.responsive.hp(93),
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: ctrl.contentScrollController,
                        child: SingleChildScrollView(
                          controller: ctrl.contentScrollController,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ctrl.responsive.wp(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    ToolsHelper.htmlParser(item.name),
                                    style: TextStyle(
                                      fontSize: ctrl.responsive.ip(2.4),
                                      color: Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                customYMargin(ctrl.responsive.hp(1)),
                                SizedBox(
                                  width: ctrl.responsive.wp(100),
                                  //height: ctrl.responsive.hp(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      httpHeaders: const {
                                        'User-Agent':
                                            'Mozilla/5.0 (Windows NT 10.0; Win64)',
                                      },
                                      height: ctrl.responsive.hp(25),
                                      imageUrl: item.image,
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
                                customYMargin(ctrl.responsive.hp(1)),
                                Text(
                                  ToolsHelper.htmlParser(item.description),
                                  style: TextStyle(
                                    fontSize: ctrl.responsive.ip(1.8),
                                    color: Get.theme.colorScheme.primary,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                // customYMargin(ctrl.responsive.hp(1)),
                                // Container(
                                //   width: ctrl.responsive.wp(100),
                                //   padding: EdgeInsets.only(
                                //     bottom: ctrl.responsive.hp(1),
                                //     right: ctrl.responsive.wp(10),
                                //     left: ctrl.responsive.wp(10),
                                //   ),
                                //   child: ElevatedButton(
                                //     style: ButtonStyle(
                                //         shape: MaterialStateProperty.all<
                                //             RoundedRectangleBorder>(
                                //           RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(
                                //                 ctrl.responsive.ip(2)),
                                //           ),
                                //         ),
                                //         backgroundColor:
                                //             MaterialStateColor.resolveWith(
                                //                 (states) => Get.theme
                                //                     .colorScheme.primary)),
                                //     child: Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           vertical: ctrl.responsive.hp(1)),
                                //       child: Row(
                                //         children: [
                                //           Expanded(
                                //             child: Icon(
                                //               Icons.stacked_bar_chart,
                                //               size: ctrl.responsive.ip(2.5),
                                //               color: Get.theme.cardColor,
                                //             ),
                                //           ),
                                //           Expanded(
                                //             flex: 2,
                                //             child: Text(
                                //               'Ver estadísticas',
                                //               style: Get.textTheme.titleLarge
                                //                   ?.copyWith(
                                //                 fontSize: ctrl.responsive.ip(2),
                                //                 fontWeight: FontWeight.bold,
                                //                 color: Get.theme.cardColor,
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //     onPressed: () {
                                //       ctrl.navigateToUrl('da');
                                //     },
                                //   ),
                                // ),
                                customYMargin(ctrl.responsive.hp(1)),
                                Text(
                                  'Equipo',
                                  style: TextStyle(
                                    fontSize: ctrl.responsive.ip(2.2),
                                    color: Get.theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // customYMargin(ctrl.responsive.hp(1)),
                                // SizedBox(
                                //   width: ctrl.responsive.wp(100),
                                //   //height: ctrl.responsive.hp(10),
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(10),
                                //     child: CachedNetworkImage(
                                //       height: ctrl.responsive.hp(25),
                                //       imageUrl: item.equipo,
                                //       fit: BoxFit.contain,
                                //       errorWidget: (context, a, b) {
                                //         return Image.asset(
                                //             'assets/images/alt-image.png');
                                //       },
                                //       placeholder: (context, url) => Image.asset(
                                //           'assets/images/alt-image.png'),
                                //     ),
                                //   ),
                                // ),
                                customYMargin(ctrl.responsive.hp(2)),
                                SizedBox(
                                  height: ctrl.responsive.hp(33),
                                  width: double.infinity,
                                  child: ListView.separated(
                                    controller: ctrl.scrollController,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      width: ctrl.responsive.wp(2.5),
                                    ),
                                    itemCount: item.members.length,
                                    itemBuilder: (context, index) {
                                      var member = item.members[index];
                                      return InkWell(
                                        //onTap: () => null,
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
                                                    color: Get.theme.colorScheme
                                                        .primary,
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
                                                    height:
                                                        ctrl.responsive.hp(5),
                                                    imageUrl: member.image,
                                                    fit: BoxFit.contain,
                                                    errorWidget:
                                                        (context, a, b) {
                                                      return Image.asset(
                                                          'assets/images/alt-image.png');
                                                    },
                                                    placeholder: (context,
                                                            url) =>
                                                        Image.asset(
                                                            'assets/images/alt-image.png'),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
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
                                                        fontSize: ctrl
                                                            .responsive
                                                            .ip(1.7),
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                                                FontWeight
                                                                    .normal,
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
                                                thickness:
                                                    ctrl.responsive.hp(0.8),
                                                color: Get
                                                    .theme.colorScheme.tertiary,
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
                        ),
                      ),
                    ),
                    const FooterUTPL(),
                  ],
                )
              : const SkeletonList(length: 20);
        },
      ),
    );
  }
}
