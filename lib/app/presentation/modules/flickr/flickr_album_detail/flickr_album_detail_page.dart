import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wall_layout/flutter_wall_layout.dart';

import 'package:get/get.dart';
import 'package:text_marquee/text_marquee.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/flickr/flickr_album_detail/flickr_album_detail_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/footer_utpl.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/loading_utpl.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';

class FlickrAlbumDetailPage extends GetView<FlickrAlbumDetailController> {
  const FlickrAlbumDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<FlickrAlbumDetailController>(
        init: FlickrAlbumDetailController(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: ctrl.responsive.wp(100),
                    height: ctrl.responsive.hp(8),
                    child: Obx(
                          () => Container(
                        alignment: Alignment.center,
                        child: TextMarquee(
                          ctrl.title.value,
                          spaceSize: 72,
                          style: TextStyle(
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                          rtl: false,
                          curve: Curves.linear,
                          delay: Duration(seconds: 1),
                          duration: Duration(
                            seconds: (ctrl.title.value.length.toDouble() * 0.30)
                                .toInt(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  customYMargin(ctrl.responsive.hp(1)),
                  ctrl.showSkeleton.isFalse
                      ? Expanded(
                    child: WallLayout(
                      stonePadding: 5,
                      stones: buildStones(ctrl, context),
                      layersCount: 4,
                      scrollDirection: Axis.vertical,
                      reverse: false,
                    ),
                  )
                      : const Expanded(child: LoadingUtpl()),
                  const FooterUTPL(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Stone> buildStones(
      FlickrAlbumDetailController ctrl, BuildContext context) {
    List<Stone> items = [];

    for (var i = 0; i < ctrl.albumFlicker.length; i++) {
      items.add(
        Stone(
          id: i,
          width: ctrl.albumFlicker[i].heightM > ctrl.albumFlicker[i].widthM
              ? 1
              : 2,
          height: ctrl.albumFlicker[i].heightM > ctrl.albumFlicker[i].widthM
              ? 2
              : 1,
          child: InkWell(
            onTap: () {
              ctrl.showModalImg(context, i, ctrl);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Get.theme.cardColor,
                child: CachedNetworkImage(
                  httpHeaders: const {
                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64)',
                  },
                  cacheKey: ctrl.albumFlicker[i].urlM,
                  placeholder: (context, url) =>
                      Image.asset('assets/images/alt-image.png'),
                  imageUrl: ctrl.albumFlicker[i].urlM,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return items;
  }
}
