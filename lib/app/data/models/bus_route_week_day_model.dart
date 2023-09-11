// To parse this JSON data, do
//
//     final busRouteWeekDayModel = busRouteWeekDayModelFromJson(jsonString);

import 'dart:convert';

List<BusRouteWeekDayModel> busRouteWeekDayModelFromJson(String str) =>
    List<BusRouteWeekDayModel>.from(
        json.decode(str).map((x) => BusRouteWeekDayModel.fromJson(x)));

String busRouteWeekDayModelToJson(List<BusRouteWeekDayModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<BusRouteWeekDayModel> busRouteWeekDayModelFromList(
        List<dynamic> listDynamic) =>
    List<BusRouteWeekDayModel>.from(
        listDynamic.map((x) => BusRouteWeekDayModel.fromJson(x)));

class BusRouteWeekDayModel {
  String startHour;
  List<BRWDRoute> routes;

  BusRouteWeekDayModel({
    required this.startHour,
    required this.routes,
  });

  factory BusRouteWeekDayModel.fromJson(Map<String, dynamic> json) =>
      BusRouteWeekDayModel(
        startHour: json["start_hour"],
        routes: List<BRWDRoute>.from(
            json["routes"].map((x) => BRWDRoute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "start_hour": startHour,
        "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
      };
}

class BRWDRoute {
  String id;
  String name;
  String line;

  BRWDRoute({
    required this.id,
    required this.name,
    required this.line,
  });

  factory BRWDRoute.fromJson(Map<String, dynamic> json) => BRWDRoute(
        id: json["id"],
        name: json["name"],
        line: json["line"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "line": line,
      };
}
