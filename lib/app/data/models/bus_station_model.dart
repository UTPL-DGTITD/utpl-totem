// To parse this JSON data, do
//
//     final busStationModel = busStationModelFromJson(jsonString);

import 'dart:convert';

List<BusStationModel> busStationModelFromJson(String str) =>
    List<BusStationModel>.from(
        json.decode(str).map((x) => BusStationModel.fromJson(x)));

String busStationModelToJson(List<BusStationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<BusStationModel> busStationModelFromList(List<dynamic> listDynamic) =>
    List<BusStationModel>.from(
        listDynamic.map((x) => BusStationModel.fromJson(x)));

class BusStationModel {
  String id;
  String name;
  Location location;
  String appCreatedId;
  String zoneId;
  String address;
  bool enabled;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  int number;

  BusStationModel({
    required this.id,
    required this.name,
    required this.location,
    required this.appCreatedId,
    required this.zoneId,
    required this.address,
    required this.enabled,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.number,
  });

  factory BusStationModel.fromJson(Map<String, dynamic> json) =>
      BusStationModel(
        id: json["_id"],
        name: json["name"],
        location: Location.fromJson(json["location"]),
        appCreatedId: json["app_created_id"],
        zoneId: json["zone_id"],
        address: json["address"] ?? '',
        enabled: json["enabled"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        number: json["number"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "location": location.toJson(),
        "app_created_id": appCreatedId,
        "zone_id": zoneId,
        "address": address,
        "enabled": enabled,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "number": number,
      };
}

class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}
