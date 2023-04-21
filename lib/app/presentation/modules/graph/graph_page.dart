import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/presentation/modules/graph/graph_controller.dart';

class GraphPage extends GetView<GraphController> {
  final TvTemplateBody item;
  const GraphPage(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      GraphController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
      ),
    );
    ctrl.currentItem.value = item;
    // ctrl.load(item.embeddedYoutube);
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<GraphController>(
        init: GraphController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return Container(
            color: Get.theme.canvasColor,
            padding: EdgeInsets.symmetric(
              vertical: ctrl.responsive.hp(2),
            ),
            child: Column(
              children: [
                Text(
                  ctrl.currentItem.value.title,
                  style: TextStyle(
                    fontSize: ctrl.responsive.ip(1.5),
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ctrl.responsive.wp(0),
                            vertical: ctrl.responsive.hp(2),
                          ),
                          // color: Colors.red,
                          child: Center(
                              child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ctrl.responsive.wp(2),
                                  vertical: ctrl.responsive.hp(2),
                                ),
                                child: Chart(
                                  state: ChartState<void>(
                                    data: ChartData.fromList(
                                      ctrl
                                          .getGraphValues(
                                              ctrl.currentItem.value)
                                          .map(
                                            (e) =>
                                                ChartItem<void>(e.toDouble()),
                                          )
                                          .toList(),
                                      axisMax: 8,
                                    ),
                                    itemOptions: BarItemOptions(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ctrl.responsive.wp(0.2),
                                      ),
                                      barItemBuilder: (index) =>
                                          // item.embeddedData[index.itemIndex]
                                          BarItem(
                                        // color: Get.theme.colorScheme.tertiary
                                        //     .withOpacity(0.8)),

                                        color: Color(int.parse(ctrl
                                                .currentItem
                                                .value
                                                .graphData[index.itemIndex]
                                                .color))
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    backgroundDecorations: [
                                      GridDecoration(
                                        textStyle: TextStyle(
                                          fontSize: ctrl.responsive.ip(1),
                                          color: Get.theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        showHorizontalValues: true,
                                        // showVerticalValues: true,
                                        verticalAxisStep: 1,
                                        horizontalAxisStep: 10,
                                        gridColor: Get.theme.dividerColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Center(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var i = 0;
                                      i <
                                          ctrl.currentItem.value.graphData
                                              .length;
                                      i++) ...[
                                    InfoGraph(
                                        ctrl: ctrl,
                                        item: ctrl
                                            .currentItem.value.graphData[i]),
                                  ],
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InfoGraph extends StatelessWidget {
  final GraphController ctrl;
  final GraphData item;
  const InfoGraph({
    Key? key,
    required this.ctrl,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
            radius: ctrl.responsive.ip(0.75),
            backgroundColor: Color(int.parse(item.color)),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            item.title,
            style: TextStyle(
              fontSize: ctrl.responsive.ip(1.5),
              color: Get.theme.colorScheme.primary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            item.value.toString(),
            style: TextStyle(
              fontSize: ctrl.responsive.ip(1.5),
              color: Get.theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
