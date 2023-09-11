import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:timelines/timelines.dart';
import 'package:utpl_totem/app/presentation/modules/bus_routes/bus_schedule_controller.dart';
import 'package:utpl_totem/app/themes/app_theme.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/extensions/date_extensions.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class ModalBusScheduleDetail {
  static Future<dynamic> showBusScheduleDetail(
      BuildContext context, BusScheduleController ctrl) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          Responsive responsive = Responsive();
          ScrollController contentScrollController = ScrollController();
          return AlertDialog(
            insetPadding: EdgeInsets.only(
              top: responsive.hp(2),
              bottom: responsive.hp(5),
              left: responsive.wp(8),
              right: responsive.wp(8),
            ),
            backgroundColor: Get.theme.canvasColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.wp(0),
              vertical: responsive.hp(2),
            ),
            title: SizedBox(
              // height: ctrl.responsive.hp(11),
              child: Text(
                ToolsHelper.htmlParser(
                    'Línea ${ctrl.routeSchedule.value.line}: ${ctrl.routeSchedule.value.name}'),
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: responsive.ip(2.2),
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              // color: Colors.red,
              // height: responsive.hp(200),
              width: responsive.wp(100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: responsive.hp(27),
                    width: responsive.wp(100),
                    child: FlutterMap(
                      mapController: ctrl.mapController.value,
                      options: MapOptions(
                        rotation: 90,
                        zoom: 10.0,
                        minZoom: 1.0,
                        maxZoom: 18.0,
                        onMapReady: () {
                          ctrl.initTimerMapChanger();
                          ctrl.update();
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.thunderforest.com/transport/{z}/{x}/{y}.png?apikey=f7ad4a23545846299ebd1d1f2dfa96b4',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        Obx(
                          () => PolylineLayer(
                            polylines: [
                              ctrl.polylineStart.value,
                            ],
                          ),
                        ),
                        Obx(
                          () => PolylineLayer(
                            polylines: [
                              ctrl.polylineFinish.value,
                            ],
                          ),
                        ),
                        MarkerLayer(
                          markers: ctrl.stops,
                        ),
                        MarkerLayer(
                          markers: ctrl.markers,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: ctrl.responsive.hp(9),
                    color: Get.theme.colorScheme.secondaryContainer,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var item = ctrl.schedule[index];
                          return Card(
                            elevation: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(2),
                                  vertical: responsive.hp(0.2)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Bus ${item.busNumber}',
                                    style:
                                        Get.textTheme.headlineSmall?.copyWith(
                                      fontSize: responsive.ip(1.5),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    item.contractDays(),
                                    style: Get.textTheme.bodyLarge?.copyWith(
                                      fontSize: responsive.ip(1.5),
                                    ),
                                  ),
                                  Text(
                                    item.startHour.convertToTime(),
                                    style: Get.textTheme.bodyLarge?.copyWith(
                                      fontSize: responsive.ip(1.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: ctrl.schedule.length),
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: contentScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        // controller: contentScrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              // height: ctrl.responsive.hp(24),
                              child: ListView.builder(
                                controller: contentScrollController,
                                shrinkWrap: true,
                                itemCount: ctrl
                                    .routeSchedule.value.routeMap!.stops.length,
                                itemBuilder: (context, index) {
                                  return Obx(
                                    () {
                                      var item = ctrl.routeSchedule.value
                                          .routeMap!.stops[index];

                                      Color? connectorColor;
                                      if (index ==
                                              ctrl.stationSelectedIndex.value ||
                                          index - 1 ==
                                              ctrl.stationSelectedIndex.value) {
                                        connectorColor =
                                            AuxSchema.successColorLight;
                                      }
                                      return TimelineTheme(
                                        data: TimelineThemeData(
                                          nodePosition: 0,
                                          nodeItemOverlap: true,
                                          connectorTheme: ConnectorThemeData(
                                            color: const Color(0xffe6e7e9),
                                            thickness: ctrl.responsive.wp(4),
                                          ),
                                        ),
                                        child: TimelineTile(
                                          node: TimelineNode(
                                            indicator: OutlinedDotIndicator(
                                              color: ctrl.stationSelectedIndex
                                                          .value ==
                                                      index
                                                  ? AuxSchema.successColorLight
                                                  : const Color(0xffe6e7e9),
                                              backgroundColor: ctrl
                                                          .stationSelectedIndex
                                                          .value ==
                                                      index
                                                  ? const Color(0xffd4f5d6)
                                                  : const Color(0xffc2c5c9),
                                              borderWidth: ctrl
                                                          .stationSelectedIndex
                                                          .value ==
                                                      index
                                                  ? 3.0
                                                  : 2.5,
                                            ),
                                            startConnector: index != 0
                                                ? index - 1 ==
                                                        ctrl.stationSelectedIndex
                                                            .value
                                                    ? SolidLineConnector(
                                                        color: connectorColor,
                                                      )
                                                    : const SolidLineConnector(
                                                        color: null,
                                                      )
                                                : null,
                                            endConnector: index !=
                                                    ctrl
                                                            .routeSchedule
                                                            .value
                                                            .routeMap!
                                                            .stops
                                                            .length -
                                                        1
                                                ? index - 1 ==
                                                        ctrl.stationSelectedIndex
                                                            .value
                                                    ? const SolidLineConnector(
                                                        color: null,
                                                      )
                                                    : SolidLineConnector(
                                                        color: connectorColor,
                                                      )
                                                : null,
                                          ),
                                          contents: Card(
                                            elevation: 1,
                                            child: Container(
                                              // color: Colors.red,
                                              height: ctrl.responsive.hp(7),
                                              padding: EdgeInsets.zero,
                                              child: ListTile(
                                                onTap: () {
                                                  ctrl.centerMapStation(item);
                                                  ctrl.updateSelectedIndex(
                                                      index);
                                                },
                                                title: Text(
                                                  '${(index + 1)}. ${item.name}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        ctrl.responsive.ip(2),
                                                  ),
                                                ),
                                                // subtitle: Text('item.address'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
                        ctrl.markers.value = [];
                        ctrl.stops.value = [];
                        ctrl.polylineStart = Polyline(points: []).obs;
                        ctrl.polylineFinish = Polyline(points: []).obs;
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
