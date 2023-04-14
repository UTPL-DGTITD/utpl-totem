import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';

import 'package:utpl_totem/app/presentation/modules/schedule/schedule_controller.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class ModalDialogBuildings {
  static Future<dynamic> showModalList({
    required String title,
    required String type,
    required BuildContext context,
    required RxList<GenericListItemModel> items,
    required ScheduleController ctrl,
    required ScrollController scrollController,
    required bool isLoading,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          Responsive responsive = Responsive();
          return AlertDialog(
            insetPadding: EdgeInsets.only(
              top: responsive.hp(15),
              bottom: responsive.hp(18),
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
                title,
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
            content: Obx(() => Column(
                  children: [
                    Expanded(
                      child: Container(
                        //width: double.infinity,
                        height: responsive.hp(50),
                        width: responsive.wp(100),
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                          vertical: responsive.hp(2),
                        ),
                        child: Scrollbar(
                          controller: scrollController,
                          thumbVisibility: true,
                          child: ListView.separated(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) => Column(
                              children: [
                                customYMargin(ctrl.responsive.hp(0.5)),
                                Divider(
                                  height: ctrl.responsive.hp(1),
                                ),
                                customYMargin(ctrl.responsive.hp(0.5)),
                              ],
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              var item = items[index];
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: ctrl.responsive.wp(0.2),
                                ),
                                child: ListTile(
                                  onTap: () =>
                                      ctrl.onSelectBuilding(type, item),
                                  title: Text(
                                    ToolsHelper.htmlParser(item.title),
                                    style: TextStyle(
                                      fontSize: ctrl.responsive.ip(2.2),
                                      color: Get.theme.colorScheme.primary,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 3,
                                  ),
                                  trailing: Icon(
                                    UtplCustom.right_small_arrow,
                                    size: ctrl.responsive.ip(2.5),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    ctrl.loadingBuildings.isTrue
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                    ctrl.loadingClassrooms.isTrue
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                  ],
                )),
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
