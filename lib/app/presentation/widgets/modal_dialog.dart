import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
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
          return AlertDialog(
            backgroundColor: Get.theme.canvasColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.wp(3),
              vertical: responsive.hp(1),
            ),
            title: Center(
              child: Text(
                ToolsHelper.htmlParser(item.title),
                style: Get.textTheme.headline6?.copyWith(
                  fontSize: responsive.ip(1.75),
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              width: responsive.wp(80),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                        vertical: responsive.hp(2),
                      ),
                      child: SizedBox(
                        height: responsive.hp(50),
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: CachedNetworkImage(
                            imageUrl: item.image?.url ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, a, b) {
                              return Image.asset('assets/images/alt-image.png');
                            },
                            placeholder: (context, url) =>
                                Image.asset('assets/images/alt-image.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                          vertical: responsive.hp(2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              ToolsHelper.htmlParser(item.description),
                              style: Get.textTheme.headline6?.copyWith(
                                fontSize: responsive.ip(1.5),
                                fontWeight: FontWeight.normal,
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Get.theme.colorScheme.error)),
                      child: Text(
                        'Cerrar',
                        style: Get.textTheme.headline6?.copyWith(
                          fontSize: responsive.ip(1.5),
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onError,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
