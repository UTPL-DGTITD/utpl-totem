// To parse this JSON data, do
//
//     final busRouteDetailModel = busRouteDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:utpl_totem_oficial/app/data/models/bus_route_schedule_model.dart';
import 'package:utpl_totem_oficial/app/data/models/bus_station_model.dart';

BusRouteDetailModel busRouteDetailModelFromJson(String str) =>
    BusRouteDetailModel.fromJson(json.decode(str));

String busRouteDetailModelToJson(BusRouteDetailModel data) =>
    json.encode(data.toJson());

class BusRouteDetailModel {
  String id;
  String line;
  String color;
  int kradakId;
  List<String> way;
  String name;
  bool enable;
  DateTime? createdAt;
  RouteMap? routeMap;
  List<BusRouteScheduleModel> busRouteSchedules;

  BusRouteDetailModel({
    this.id = '',
    this.line = '',
    this.color = '',
    this.kradakId = 0,
    this.way = const [],
    this.name = '',
    this.enable = false,
    this.createdAt,
    this.routeMap,
    this.busRouteSchedules = const [],
  });

  factory BusRouteDetailModel.fromJson(Map<String, dynamic> json) =>
      BusRouteDetailModel(
        id: json["id"],
        line: json["line"],
        color: json["color"] ?? "",
        kradakId: json["kradak_id"] ?? 0,
        way: List<String>.from(json["way"].map((x) => x)),
        name: json["name"],
        enable: json["enable"],
        createdAt: DateTime.parse(json["created_at"]),
        routeMap: RouteMap.fromJson(json["route_map"]),
        busRouteSchedules: List<BusRouteScheduleModel>.from(
            json["bus_route_schedules"]
                .map((x) => BusRouteScheduleModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "line": line,
        "color": color,
        "kradak_id": kradakId,
        "way": List<dynamic>.from(way.map((x) => x)),
        "name": name,
        "enable": enable,
        "created_at": createdAt?.toIso8601String(),
        "route_map": routeMap?.toJson(),
        "bus_route_schedules":
            List<dynamic>.from(busRouteSchedules.map((x) => x.toJson())),
      };
}

class RouteMap {
  List<List<double>> route;
  List<BusStationModel> stops;

  RouteMap({
    required this.route,
    required this.stops,
  });

  factory RouteMap.fromJson(Map<String, dynamic> json) => RouteMap(
        route: List<List<double>>.from(json["route"]
            .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
        stops: List<BusStationModel>.from(
            json["stops"].map((x) => BusStationModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "route": List<dynamic>.from(
            route.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "stops": List<dynamic>.from(stops.map((x) => x.toJson())),
      };
}

class Location {
  Type type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: typeValues.map[json["type"]]!,
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

// ignore: constant_identifier_names
enum Type { POINT }

final typeValues = EnumValues({"Point": Type.POINT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
