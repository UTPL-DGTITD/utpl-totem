import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:utpl_totem/app/presentation/modules/news/news_controller.dart';
import 'package:utpl_totem/app/presentation/widgets/modal_dialog.dart';
import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';
import 'package:intl/src/intl/date_format.dart';

class NewsPage extends GetView<NewsController> {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<NewsController>(
        init: NewsController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
              child: ctrl.showSkeleton.isFalse
                  ? Obx(
                      () =>
                          // TYPE: INTERACTIVE LIST
                          Container(
                        width: double.infinity,
                        color: Get.theme.cardColor,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: ctrl.responsive.hp(0.5),
                                horizontal: ctrl.responsive.wp(1),
                              ),
                              // color: Get.theme.colorScheme.primary,
                              child: Text(
                                ctrl.title.value,
                                style: TextStyle(
                                  fontSize: ctrl.responsive.ip(1.8),
                                  color: Get.theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(1)),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: ctrl.responsive.hp(0.5),
                                  horizontal: ctrl.responsive.wp(1),
                                ),
                                child: ListView.builder(
                                  controller: ctrl.scrollController,
                                  itemCount: ctrl.news.length,
                                  itemBuilder: (context, index) {
                                    var item = ctrl.news[index];
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: ctrl.responsive.wp(0.2)),
                                      child: ListTile(
                                        // minLeadingWidth: ctrl.responsive.wp(10),
                                        onTap: () => ModalDialog.alertFeatures(
                                            context, item),
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: SizedBox(
                                            height: ctrl.responsive.hp(8),
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: CachedNetworkImage(
                                                imageUrl: item.image?.url ?? '',
                                                fit: BoxFit.cover,
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
                                        ),
                                        title: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: ctrl.responsive.ip(1.65),
                                            color:
                                                Get.theme.colorScheme.primary,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        subtitle: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   item.description,
                                            //   maxLines: 1,
                                            //   overflow: TextOverflow.ellipsis,
                                            // ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  UtplCustom.calendar,
                                                  size: ctrl.responsive.ip(1.6),
                                                  color:
                                                      Get.theme.iconTheme.color,
                                                ),
                                                customXMargin(
                                                    ctrl.responsive.wp(1)),
                                                Text(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(item.date!),
                                                  style: TextStyle(
                                                    fontSize:
                                                        ctrl.responsive.ip(1.5),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(
                                          UtplCustom.right_small_arrow,
                                          size: ctrl.responsive.ip(2),
                                        ),
                                      ),
                                    );
                                  },
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
                  : const SkeletonList(length: 20));
        },
      ),
    );
  }
}
