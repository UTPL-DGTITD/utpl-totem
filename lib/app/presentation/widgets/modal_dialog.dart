import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class ModalDialog {
  static Future<dynamic> alertFeatures(
      BuildContext context, GenericListItemModel item) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          Responsive responsive = Responsive();
          ScrollController _contentScrollController = ScrollController();
          return AlertDialog(
            insetPadding: EdgeInsets.only(
              left: responsive.wp(12),
              right: responsive.wp(12),
            ),
            backgroundColor: Get.theme.canvasColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.wp(5),
              vertical: responsive.hp(1),
            ),
            title: Container(
              width: responsive.wp(50),
              child: Text(
                ToolsHelper.htmlParser(item.title),
                style: Get.textTheme.headline6?.copyWith(
                  fontSize: responsive.ip(2.2),
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: responsive.hp(50),
              child: Scrollbar(
                controller: _contentScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _contentScrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.wp(2),
                      vertical: responsive.hp(2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.wp(2),
                            vertical: responsive.hp(2),
                          ),
                          child: SizedBox(
                            height: responsive.hp(25),
                            // width: responsive.wp(80),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: CachedNetworkImage(
                                imageUrl: item.image?.url ?? '',
                                fit: BoxFit.contain,
                                errorWidget: (context, a, b) {
                                  return Image.asset(
                                      'assets/images/alt-image.png');
                                },
                                placeholder: (context, url) =>
                                    Image.asset('assets/images/alt-image.png'),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          ToolsHelper.htmlParser(item.description),
                          style: Get.textTheme.headline6?.copyWith(
                            fontSize: responsive.ip(1.8),
                            fontWeight: FontWeight.normal,
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: responsive.wp(35),
                    padding: EdgeInsets.only(bottom: responsive.hp(1)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(responsive.ip(2)),
                            ),
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Get.theme.colorScheme.error)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: responsive.hp(1)),
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
                                style: Get.textTheme.headline6?.copyWith(
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
        });
  }
}
