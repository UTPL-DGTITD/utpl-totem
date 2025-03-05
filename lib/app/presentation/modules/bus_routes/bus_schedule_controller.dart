import 'dart:async';
import 'dart:io';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:utpl_totem_oficial/app/data/models/bus_route_detail_model.dart';
import 'package:utpl_totem_oficial/app/data/models/bus_route_schedule_model.dart';

import 'package:utpl_totem_oficial/app/data/models/bus_route_week_day_model.dart';
import 'package:utpl_totem_oficial/app/data/models/bus_station_model.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/bus_routes/widgets/modal_bus_schedule_detail.dart';
import 'package:utpl_totem_oficial/app/routes/app_pages.dart';
import 'package:utpl_totem_oficial/app/themes/app_theme.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

class BusScheduleController extends GetxController {
  final ApiRepository apiRepository;
  final ToastService toastService;

  BusScheduleController({
    required this.apiRepository,
    required this.toastService,
  });

  final busRoutes = <DayEvent<BRWDRoute>>[].obs;
  final currentDate = DateTime.now().obs;
  final responsive = Responsive();
  final mapController = MapController().obs;
  final stationSelectedIndex = 0.obs;
  final Rx<BusRouteDetailModel> routeSchedule = BusRouteDetailModel().obs;
  final schedule = <BusRouteScheduleModel>[].obs;

  // MODAL
  final markers = <Marker>[].obs;
  final stops = <Marker>[].obs;
  var polylineStart = Polyline(points: []).obs;
  var polylineFinish = Polyline(points: []).obs;
  final mapBounds = Rxn<LatLngBounds>();
  RxBool hasMapBounds = false.obs;

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  void _initConfig() async {
    toastService.presentLoading();
    try {
      var dayOfWeek = currentDate.value.weekday;
      getBusRoutes(dayOfWeek: dayOfWeek);
      toastService.hideLoading();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[bus_schedule_controller](_initConfig) -> [error]',
        error: error,
        stackTrace: stack,
      );
      toastService.hideLoading();
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  getBusRoutes({
    required int dayOfWeek,
  }) async {
    try {
      toastService.presentLoading();
      busRoutes.clear();
      var result =
          await apiRepository.postBusesRoutesByWeekDay(weekDay: dayOfWeek);
      switch (result.status) {
        case 200:
          final busRouteWeekDayModel =
              busRouteWeekDayModelFromList(result.data);
          for (var element in busRouteWeekDayModel) {
            for (var route in element.routes) {
              busRoutes.add(
                DayEvent(
                  name: route.name,
                  start: parseDate(element.startHour),
                  end: parseDate(element.startHour).add(
                    const Duration(
                      minutes: 30,
                    ),
                  ),
                  value: route,
                ),
              );
            }
          }
          ToolsHelper.logger.v(
            '[bus_schedule_controller](getBusRoutes) -> [busRoutes]',
            error: busRoutes,
          );
          update();
          break;
        case 404:
          toastService.presentWarningToast(
            text: "No se encontraron rutas de buses para este día",
          );
          break;
        default:
      }
    } on TimeoutException {
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
      toastService.hideLoading();
      Get.offNamedUntil(Routes.network_error, (route) => false);
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[bus_schedule_controller](getBusRoutes) -> [error])',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Ocurrió un error, intenta nuevamente.',
      );
    } finally {
      toastService.hideLoading();
    }
  }

  parseDate(String hour) {
    DateTime nowDate = DateTime.now();

    List<String> splitHour = hour.split(':');

    if (splitHour.length != 2) {
      splitHour = ['00', '00'];
    }
    int hours = int.parse(splitHour[0]);
    int minutes = int.parse(splitHour[1]);

    nowDate = nowDate.copyWith(hour: hours, minute: minutes);

    return nowDate;
  }

  String getDayName({required int weekDay}) {
    switch (weekDay) {
      case 1:
        return "Lunes";
      case 2:
        return "Martes";
      case 3:
        return "Miércoles";
      case 4:
        return "Jueves";
      case 5:
        return "Viernes";
      case 6:
        return "Sábado";
      case 7:
        return "Domingo";
      default:
        return "Lunes";
    }
  }

  nextDay() {
    currentDate.value = currentDate.value.add(
      const Duration(
        days: 1,
      ),
    );
    busRoutes.clear();
    update();
    getBusRoutes(dayOfWeek: currentDate.value.weekday);
  }

  previousDay() {
    currentDate.value = currentDate.value.subtract(
      const Duration(
        days: 1,
      ),
    );
    busRoutes.clear();
    update();
    getBusRoutes(dayOfWeek: currentDate.value.weekday);
  }

  void navigateToBusRouteDetailPage({required BRWDRoute busRoute}) {
    Get.toNamed('ruta', arguments: {
      'bus_route_id': busRoute.id,
    });
  }

  Future<void> loadRouteShedule(
    BuildContext context,
    String id,
    BusScheduleController ctrl,
  ) async {
    try {
      var result = await apiRepository.showBusRoute(id: id);
      switch (result.status) {
        case 200:
          routeSchedule.value = BusRouteDetailModel.fromJson(result.data);
          schedule.assignAll(routeSchedule.value.busRouteSchedules);
          ToolsHelper.logger.v('Existe ruta');
          // ignore: use_build_context_synchronously
          showModal(context, ctrl);

          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
    } on TimeoutException {
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[bus_schedule_controller] (loadRouteShedule)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void showModal(BuildContext context, BusScheduleController ctrl) {
    ModalBusScheduleDetail.showBusScheduleDetail(
      context,
      ctrl,
    );
  }

  void initTimerMapChanger() async {
    mapController.value.move(
      const LatLng(-3.9871071635890303, -79.19839998374741),
      18,
    );
    changueMarkers(routeSchedule.value);
  }

  void changueMarkers(BusRouteDetailModel item) {
    var responsive = Responsive();
    stops.clear();
    markers.clear();
    if (item.routeMap!.route.isNotEmpty) {
      markers.assignAll([
        Marker(
          width: responsive.wp(10),
          height: responsive.hp(10),
          point: LatLng(
              item.routeMap!.route.first[1], item.routeMap!.route.first[0]),
          child: Transform.rotate(
            angle: 3.14159265359 * 1.5, // 270 grados en radianes(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/marker-point.svg',
                  height: 35,
                ),
                Text(
                  'UTPL',
                  style: TextStyle(
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(1.2),
                  ),
                ),
              ],
            ),
          ),
        ),
        Marker(
          width: responsive.wp(10),
          height: responsive.hp(10),
          point: LatLng(
              item.routeMap!.route.last[1], item.routeMap!.route.last[0]),
          child: Transform.rotate(
            angle: 3.14159265359 * 1.5, // 270 grados en radianes((
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/marker-point.svg',
                  height: 35,
                ),
                Icon(
                  Icons.pin_drop_sharp,
                  color: Get.theme.colorScheme.primary,
                  size: responsive.ip(2),
                ),
              ],
            ),
          ),
        ),
      ]);
    }
    generateRoutePolyline(item);
    loadStops(item);
  }

  void generateRoutePolyline(BusRouteDetailModel item) {
    mapBounds.value = LatLngBounds.fromPoints(getPoints(item.routeMap!.route));

    LatLngBounds? bounds = mapBounds.value;
    if (bounds != null && getPoints(item.routeMap!.route).isNotEmpty) {
      hasMapBounds.value = true;
      //mapBounds.value.fitBounds(bounds);
    } else {
      hasMapBounds.value = false;
    }
    final points = <LatLng>[];
    for (var element in item.routeMap!.route) {
      points.add(LatLng(element[1], element[0]));
    }
    if (item.way.length > 1) {
      // Poliguno mitad ruta
      polylineStart.value = Polyline(
        points: points.sublist(0, points.length ~/ 2),
        strokeWidth: 2,
        color: AuxSchema.successColorDark,
      );
      // Poliguno mitad ruta 2
      polylineFinish.value = Polyline(
        points: points.sublist(points.length ~/ 2),
        strokeWidth: 2,
        color: Get.theme.colorScheme.primary,
      );
    } else {
      polylineStart.value = Polyline(
        points: points,
        strokeWidth: 2,
        color: AuxSchema.successColorDark,
      );
    }
    update();
  }

  List<LatLng> getPoints(List<List<double>> routes) {
    if (routes.isNotEmpty) {
      return routes.map((route) => LatLng(route[1], route[0])).toList();
    } else {
      return [];
    }
  }

  void loadStops(BusRouteDetailModel item) {
    List<Marker> busStops = [];
    stops.clear();
    if (item.routeMap!.stops.isNotEmpty) {
      for (var i = 0; i < item.routeMap!.stops.length; i++) {
        busStops.add(
          Marker(
            width: responsive.wp(8),
            height: responsive.hp(8),
            point: LatLng(item.routeMap!.stops[i].location.coordinates[1],
                item.routeMap!.stops[i].location.coordinates[0]),
            child: Transform.rotate(
              angle: 3.14159265359 * 1.5, // 270 grados en radianes(((
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/marker-point.svg',
                    width: responsive.wp(8),
                    height: responsive.hp(8),
                  ),
                  Icon(
                    UtplCustom.bus_station,
                    color: Get.theme.colorScheme.primary,
                    size: responsive.ip(1.7),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      stops.assignAll(busStops);
    }
  }

  void centerMapStation(BusStationModel station) {
    mapController.value.move(
      LatLng(
        station.location.coordinates[1],
        station.location.coordinates[0],
      ),
      17,
    );
  }

  void updateSelectedIndex(int index) {
    stationSelectedIndex.value = index;
  }
}
