import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:utpl_totem_oficial/app/presentation/modules/news/news_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/loading_utpl.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/modal_dialog.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

class NewsPage extends GetView<NewsController> {
  const NewsPage({super.key});

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
      body: GetX<NewsController>(
        init: NewsController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
            child: ctrl.showSkeleton.isFalse
                ? Obx(
                    () => Container(
                      width: double.infinity,
                      color: Get.theme.cardColor,
                      child: Column(
                        children: [
                          customYMargin(ctrl.responsive.hp(1)),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ctrl.responsive.hp(0.5),
                                horizontal: ctrl.responsive.wp(1),
                              ),
                              child: Scrollbar(
                                controller: ctrl.scrollController,
                                thumbVisibility: true,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) => Column(
                                    children: [
                                      customYMargin(ctrl.responsive.hp(0.5)),
                                      Divider(
                                        height: ctrl.responsive.hp(1),
                                      ),
                                      customYMargin(ctrl.responsive.hp(0.5)),
                                    ],
                                  ),
                                  controller: ctrl.scrollController,
                                  itemCount: ctrl.news.length,
                                  itemBuilder: (context, index) {
                                    var item = ctrl.news[index];
                                    return InkWell(
                                      onTap: () => ModalDialog.alertFeatures(
                                          context, item),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: ctrl.responsive.wp(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                width: ctrl.responsive.wp(20),
                                                height: ctrl.responsive.hp(10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: CachedNetworkImage(
                                                    httpHeaders: const {
                                                      'User-Agent':
                                                          'Mozilla/5.0 (Windows NT 10.0; Win64)',
                                                    },
                                                    imageUrl:
                                                        item.image?.url ?? '',
                                                    //fit: BoxFit.cover,
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
                                            ),
                                            customXMargin(
                                                ctrl.responsive.wp(1)),
                                            Expanded(
                                              flex: 2,
                                              child: ListTile(
                                                onTap: () =>
                                                    ModalDialog.alertFeatures(
                                                        context, item),
                                                title: Text(
                                                  ToolsHelper.htmlParser(
                                                      item.title),
                                                  style: TextStyle(
                                                    fontSize:
                                                        ctrl.responsive.ip(2.2),
                                                    color: Get.theme.colorScheme
                                                        .primary,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  maxLines: 3,
                                                ),
                                                subtitle: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    customYMargin(
                                                        ctrl.responsive.hp(1)),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          UtplCustom.calendar,
                                                          size: ctrl.responsive
                                                              .ip(2),
                                                          color: Get.theme
                                                              .iconTheme.color,
                                                        ),
                                                        customXMargin(ctrl
                                                            .responsive
                                                            .wp(3)),
                                                        Text(
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  item.date!),
                                                          style: TextStyle(
                                                            fontSize: ctrl
                                                                .responsive
                                                                .ip(1.9),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                trailing: Icon(
                                                  UtplCustom.right_small_arrow,
                                                  size: ctrl.responsive.ip(2.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          ctrl.loadingNews.isTrue
                              ? const CircularProgressIndicator()
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  )
                : const LoadingUtpl(),
          );
        },
      ),
    );
  }
}
