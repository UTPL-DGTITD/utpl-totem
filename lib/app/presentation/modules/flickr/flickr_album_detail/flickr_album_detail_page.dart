import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wall_layout/flutter_wall_layout.dart';

import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:utpl_totem/app/presentation/modules/flickr/flickr_album_detail/flickr_album_detail_controller.dart';
import 'package:utpl_totem/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem/app/presentation/widgets/footer_utpl.dart';
import 'package:utpl_totem/app/presentation/widgets/loading_utpl.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';

class FlickrAlbumDetailPage extends GetView<FlickrAlbumDetailController> {
  const FlickrAlbumDetailPage({Key? key}) : super(key: key);

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
                    child: Marquee(
                      text: ctrl.title.value,
                      style: TextStyle(
                        fontSize: ctrl.responsive.ip(3),
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 20.0,
                      velocity: 25,
                      pauseAfterRound: const Duration(seconds: 0),
                      startPadding: 10.0,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationCurve: Curves.easeOut,
                    ),
                  ),
                  customYMargin(ctrl.responsive.hp(1)),
                  ctrl.showSkeleton.isFalse
                      ? Expanded(
                          child: WallLayout(
                            // scrollController: ctrl.scrollController,
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
