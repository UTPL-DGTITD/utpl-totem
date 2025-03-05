import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/flickr/flickr_album_detail/flickr_album_detail_controller.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';

class ModalImage {
  static Future<dynamic> showImage(
    BuildContext context,
    String url,
    FlickrAlbumDetailController ctrl,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        Responsive responsive = Responsive();
        return AlertDialog(
          insetPadding: EdgeInsets.only(
            top: responsive.hp(30),
            bottom: responsive.hp(15),
            left: responsive.wp(0),
            right: responsive.wp(0),
          ),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.wp(0),
            vertical: responsive.hp(1),
          ),
          title: const SizedBox(),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SizedBox(
            width: responsive.hp(100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => CachedNetworkImage(
                                httpHeaders: const {
                                  'User-Agent':
                                      'Mozilla/5.0 (Windows NT 10.0; Win64)',
                                },
                                cacheKey: ctrl.actualUrlImg.value,
                                placeholder: (context, url) =>
                                    Image.asset('assets/images/alt-image.png'),
                                imageUrl: ctrl.actualUrlImg.value,
                                fit: BoxFit.contain,
                              ),
                              //     PhotoView(
                              //   initialScale: 0.6,
                              //   minScale: 0.6,
                              //   maxScale: 1.0,
                              //   backgroundDecoration: const BoxDecoration(
                              //       color: Colors.transparent),
                              //   tightMode: true,
                              //   imageProvider: CachedNetworkImageProvider(
                              //     ctrl.actualUrlImg.value,
                              //     cacheKey: ctrl.actualUrlImg.value,
                              //   ),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: 0,
                        top: responsive.hp(15),
                        child: InkWell(
                          onTap: () =>
                              ctrl.previusImg(ctrl.actualIndexImg.value),
                          child: CircleAvatar(
                            backgroundColor: Get.theme.colorScheme.tertiary,
                            radius: responsive.ip(2.5),
                            child: Icon(
                              UtplCustom.left_small_arrow,
                              size: responsive.ip(4),
                              color: Get.theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: responsive.hp(15),
                        child: InkWell(
                          onTap: () => ctrl.nextImg(ctrl.actualIndexImg.value),
                          child: CircleAvatar(
                            backgroundColor: Get.theme.colorScheme.tertiary,
                            radius: responsive.ip(2.5),
                            child: Icon(
                              UtplCustom.right_small_arrow,
                              size: responsive.ip(4),
                              color: Get.theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  width: responsive.wp(35),
                  padding: EdgeInsets.only(bottom: responsive.hp(1)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(responsive.ip(2)),
                          ),
                        ),
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => Get.theme.colorScheme.error)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: responsive.hp(1)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.close,
                              size: responsive.ip(2.5),
                              color: Get.theme.cardColor,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Cerrar',
                              style: Get.textTheme.titleLarge?.copyWith(
                                fontSize: responsive.ip(2),
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.onError,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                customYMargin(responsive.hp(1)),
              ],
            )
          ],
        );
      },
    );
  }
}
