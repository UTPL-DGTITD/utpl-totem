// To parse this JSON data, do
//
//     final genericListItemModel = genericListItemModelFromJson(jsonString);

import 'dart:convert';

import 'package:utpl_totem/app/data/models/app_base_model.dart';
import 'package:utpl_totem/app/data/models/end_point_base_model.dart';
import 'package:utpl_totem/app/data/models/image_base_model.dart';
import 'package:utpl_totem/app/data/models/link_base_model.dart';

GenericListItemModel genericListItemModelFromJson(String str) =>
    GenericListItemModel.fromJson(json.decode(str));

String genericListItemModelToJson(GenericListItemModel data) =>
    json.encode(data.toJson());

List<GenericListItemModel> genericListItemModelFromList(
        List<dynamic> listDynamic) =>
    List<GenericListItemModel>.from(
        listDynamic.map((x) => GenericListItemModel.fromJson(x)));

class GenericListItemModel {
  GenericListItemModel({
    this.id = 0,
    this.title = "",
    this.identifier = "",
    this.description = "",
    this.typeNotify = "",
    this.acronym = "",
    this.value = 0,
    this.interaction = "",
    this.view = "",
    this.hour = "",
    this.date,
    this.source = "",
    this.dateStr = "",
    this.location = "",
    this.image,
    this.icon,
    this.link,
    this.app,
    this.type = "",
    this.rol = "",
    this.related = const [],
    this.attrs = const [],
    this.endpoint,
    this.enable = false,
    this.deprecated = false,
  });

  dynamic id;
  String title;
  String identifier;
  String description;
  String acronym;
  String typeNotify;
  int value;
  String interaction;
  String view;
  IconGeneric? icon;
  String type;
  String rol;
  String hour;
  DateTime? date;
  String source;
  String? dateStr;
  String? location;
  LinkBaseModel? link;
  ImageBaseModel? image;
  AppBaseModel? app;
  List<Related> related;
  List<Attrs> attrs;
  EndPointBaseModel? endpoint;
  bool enable;
  bool deprecated;

  factory GenericListItemModel.fromJson(Map<String, dynamic> json) {
    if (json["date"] == null &&
        json["date_str"] != null &&
        json["date_str"].toString().isNotEmpty) {
      var regex = RegExp(r"(?<date>\d{2}\/\d{1,2}\/\d{4})");
      var match = regex.firstMatch(json["date_str"]);
      final date = match?.namedGroup("date");

      regex = RegExp(r"(?<hour>\d{1,2}:\d{1,2})");
      match = regex.firstMatch(json["date_str"]);
      final hour = match?.namedGroup("hour");
      if (match != null && date != null && hour != null) {
        final dateSplit = date.split("/");
        json["date"] = "${dateSplit[2]}-${dateSplit[0]}-${dateSplit[1]}";
        json["hour"] = hour;
      }
    }

    return GenericListItemModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      identifier: json["identifier"] ?? "",
      description: json["description"] ?? "",
      typeNotify: json["type_notify"] ?? "",
      acronym: json["acronym"] ?? "",
      value: json["value"] ?? 0,
      icon: json["icon"] == null ? null : IconGeneric.fromJson(json["icon"]),
      type: json["type"] ?? "",
      rol: json["rol"] ?? "",
      hour: json["hour"] ?? "",
      date: json["date"] == null
          ? DateTime.now()
          : json["date"] == ""
              ? DateTime.now()
              : DateTime.parse(json["date"]),
      location: json["location"] ?? "",
      interaction: json["interaction"] ?? "",
      source: json["source"] ?? "",
      dateStr: json["date_str"] ?? "",
      link: json["link"] == null ? null : LinkBaseModel.fromJson(json["link"]),
      image:
          json["image"] == null ? null : ImageBaseModel.fromJson(json["image"]),
      app: json["app"] == null ? null : AppBaseModel.fromJson(json["app"]),
      related: json["related"] == null
          ? []
          : List<Related>.from(json["related"].map((x) => Related.fromJson(x))),
      attrs: json["attrs"] == null
          ? []
          : List<Attrs>.from(json["attrs"].map((x) => Attrs.fromJson(x))),
      endpoint: json["endpoint"] == null
          ? null
          : json["endpoint"] == ""
              ? null
              : EndPointBaseModel.fromJson(json["endpoint"]),
      enable: json["enable"] ?? false,
      deprecated: json["deprecated"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "identifier": identifier,
        "description": description,
        "type_notify": typeNotify,
        "acronym": acronym,
        "value": value,
        "icon": icon,
        "type": type,
        "rol": rol,
        "hour": hour,
        "date": date == null
            ? null
            : "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "location": location,
        "interaction": interaction,
        "source": source,
        "date_str": dateStr,
        "link": link == null ? link : link?.toJson(),
        "image": image == null ? image : image?.toJson(),
        "app": app == null ? app : app?.toJson(),
        "related": List<dynamic>.from(related.map((x) => x.toJson())),
        "attrs": List<dynamic>.from(attrs.map((x) => x.toJson())),
        "endpoint": endpoint?.toJson(),
        "enable": enable,
        "deprecated": deprecated,
      };
}

class Related {
  Related({
    this.type = "",
    this.identifier = "",
    this.name = "",
  });

  String type;
  String identifier;
  String name;

  factory Related.fromJson(Map<String, dynamic> json) => Related(
        type: json["type"] ?? "",
        identifier: json["identifier"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "identifier": identifier,
        "name": name,
      };
}

class Attrs {
  Attrs({
    this.name = "",
    this.value = "",
  });

  String name;
  String value;

  factory Attrs.fromJson(Map<String, dynamic> json) => Attrs(
        name: json["name"] ?? "",
        value: json["value"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}

class IconGeneric {
  IconGeneric({
    this.name = "",
    this.package = "",
  });

  String name;
  String package;

  factory IconGeneric.fromJson(Map<String, dynamic> json) => IconGeneric(
        name: json["name"],
        package: json["package"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "package": package,
      };
}
