import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/flickr/flickr_albums/flickr_albums_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/footer_utpl.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/loading_utpl.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';

class FlickrAlbumsPage extends GetView<FlickrAlbumsController> {
  const FlickrAlbumsPage({super.key});

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
            style: TextStyle(fontSize: controller.responsive.ip(3)),
          ),
        ),
        leading: const SizedBox(),
      ),
      body: GetX<FlickrAlbumsController>(
        init: FlickrAlbumsController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return Center(
            child: Container(
              width: ctrl.responsive.wp(100),
              height: ctrl.responsive.hp(100),
              color: Get.theme.canvasColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  customYMargin(ctrl.responsive.hp(1)),
                  Expanded(
                    child: ctrl.showSkeleton.isFalse
                        ? Scrollbar(
                            controller: ctrl.scrollController,
                            thumbVisibility: true,
                            child: GridView.builder(
                              controller: ctrl.scrollController,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Número de columnas
                                mainAxisExtent: ctrl.responsive.hp(25),
                              ),
                              itemCount: ctrl.albums.length,
                              itemBuilder: (context, index) {
                                var item = ctrl.albums[index];
                                return InkWell(
                                  onTap: (() => ctrl.navigateToDetail(item)),
                                  child: Card(
                                    elevation: 3,
                                    margin: EdgeInsets.symmetric(
                                      vertical: ctrl.responsive.hp(0.7),
                                      horizontal: ctrl.responsive.wp(1.8),
                                    ),
                                    child: Container(
                                      color: Get.theme.colorScheme.secondary
                                          .withOpacity(0.7),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ctrl.responsive.wp(2),
                                        vertical: ctrl.responsive.hp(1),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.title?.content ?? '',
                                                      style: TextStyle(
                                                        fontSize: ctrl
                                                            .responsive
                                                            .ip(2),
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                  Icon(
                                                    UtplCustom
                                                        .right_small_arrow,
                                                    size: ctrl.responsive.ip(3),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.image,
                                                        size: ctrl.responsive
                                                            .ip(1.7),
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          ' ${item.photos} fotos',
                                                          style: TextStyle(
                                                            fontSize: ctrl
                                                                .responsive
                                                                .ip(1.7),
                                                            color: Get
                                                                .theme
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.remove_red_eye,
                                                        size: ctrl.responsive
                                                            .ip(1.7),
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          ' ${item.countViews} vistas',
                                                          style: TextStyle(
                                                            fontSize: ctrl
                                                                .responsive
                                                                .ip(1.7),
                                                            color: Get
                                                                .theme
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.date_range,
                                                  size: ctrl.responsive.ip(1.7),
                                                  color: Get.theme.colorScheme
                                                      .primary,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    // ' ${item.photos} fotos',
                                                    ' ${DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch((int.parse(item.dateCreate)) * 1000))}',
                                                    style: TextStyle(
                                                      fontSize: ctrl.responsive
                                                          .ip(1.7),
                                                      color: Get.theme
                                                          .colorScheme.primary,
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const LoadingUtpl(),
                  ),
                  ctrl.loadingAlbum.isTrue
                      ? const CircularProgressIndicator()
                      : const SizedBox(),
                  const FooterUTPL(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
