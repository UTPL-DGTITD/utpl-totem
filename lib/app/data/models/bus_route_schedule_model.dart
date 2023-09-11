// To parse this JSON data, do
//
//     final busRouteScheduleModel = busRouteScheduleModelFromJson(jsonString);

import 'dart:convert';

List<BusRouteScheduleModel> busRouteScheduleModelFromJson(String str) =>
    List<BusRouteScheduleModel>.from(
        json.decode(str).map((x) => BusRouteScheduleModel.fromJson(x)));

String busRouteScheduleModelToJson(List<BusRouteScheduleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<BusRouteScheduleModel> busRouteScheduleModelFromList(
        List<dynamic> listDynamic) =>
    List<BusRouteScheduleModel>.from(
        listDynamic.map((x) => BusRouteScheduleModel.fromJson(x)));

class BusRouteScheduleModel {
  String id;
  DateTime startHour;
  bool enable;
  List<String> days;
  String busNumber;
  String busPlatformNumber;

  BusRouteScheduleModel({
    required this.id,
    required this.startHour,
    required this.enable,
    required this.days,
    required this.busNumber,
    required this.busPlatformNumber,
  });

  factory BusRouteScheduleModel.fromJson(Map<String, dynamic> json) =>
      BusRouteScheduleModel(
        id: json["id"],
        startHour: DateTime.parse(json["start_hour"]),
        enable: json["enable"],
        days: List<String>.from(json["days"].map((x) => x)),
        busNumber: json["bus_number"],
        busPlatformNumber: json["bus_platform_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_hour": startHour.toIso8601String(),
        "enable": enable,
        "days": List<dynamic>.from(days.map((x) => x)),
        "bus_number": busNumber,
        "bus_platform_number": busPlatformNumber,
      };

  String contractDays() {
    if (days.isNotEmpty && days.length < 3) {
      return days.reduce((value, element) => "$value | $element");
    }

    return days
        .map((e) => e.substring(0, 2))
        .reduce((value, element) => "$value | $element");
  }
}
