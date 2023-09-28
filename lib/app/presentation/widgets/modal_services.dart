import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_controller.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class ModalServices {
  static Future<dynamic> alertMoreServices(BuildContext context) {
    List<Map<String, dynamic>> serviceData = [
      {
        'title': 'Consultar Horarios',
        'route': Routes.schedule,
        'icon': UtplCustom.calendar,
      },
      {
        'title': 'Buses UTPL',
        'route': Routes.bus_schedule,
        'icon': UtplCustom.bus_station,
      },
      {
        'title': 'Noticias UTPL',
        'route': Routes.news,
        'icon': Icons.newspaper,
      },
      {
        'title': 'Eventos UTPL',
        'route': Routes.events,
        'icon': Icons.event_available,
      },
      {
        'title': 'Flickr UTPL',
        'route': Routes.flickr,
        'icon': Icons.photo,
      },
    ];
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          Responsive responsive = Responsive();
          ScrollController contentScrollController = ScrollController();
          return AlertDialog(
            insetPadding: EdgeInsets.only(
              top: responsive.hp(35),
              bottom: responsive.hp(15),
              left: responsive.wp(12),
              right: responsive.wp(12),
            ),
            backgroundColor: Get.theme.canvasColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.wp(5),
              vertical: responsive.hp(1),
            ),
            title: SizedBox(
              width: responsive.wp(50),
              child: Text(
                ToolsHelper.htmlParser('Servicios'),
                style: Get.textTheme.titleLarge?.copyWith(
                  fontSize: responsive.ip(2.4),
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: SizedBox(
              width: responsive.hp(100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: contentScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        // controller: contentScrollController,
                        child: SizedBox(
                          height: responsive.hp(30),
                          width: responsive.wp(100),
                          child: GridView.builder(
                            controller: contentScrollController,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisExtent: responsive.hp(13),
                              maxCrossAxisExtent: responsive.wp(20),
                              mainAxisSpacing: responsive
                                  .hp(1), // Espacio vertical entre elementos
                              crossAxisSpacing: responsive
                                  .wp(3), // Espacio horizontal entre elementos
                            ),
                            itemCount: serviceData
                                .length, // Cantidad de elementos en la grilla
                            itemBuilder: (BuildContext context, int index) {
                              return ServiceItem(
                                title: serviceData[index]['title'],
                                icon: serviceData[index]['icon'],
                                route: serviceData[index]['route'],
                              );
                            },
                          ),
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

class ServiceItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  const ServiceItem({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();
    HomeController ctrl = Get.find<HomeController>();
    return InkWell(
      onTap: () async {
        Get.back();
        ModalServices.alertMoreServices(context);
        ctrl.navigateToPage(route);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.wp(1),
              vertical: responsive.hp(1),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(responsive.hp(1.6)),
              color: Get.theme.colorScheme.tertiary,
            ),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Get.theme.cardColor,
                  size: responsive.ip(3.5),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: responsive.ip(1.6),
                  color: Get.theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
