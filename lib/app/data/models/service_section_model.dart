// To parse this JSON data, do
//
//     final serviceSectionModel = serviceSectionModelFromJson(jsonString);

import 'dart:convert';

import 'package:utpl_totem/app/data/models/end_point_base_model.dart';

List<ServiceSectionModel> serviceSectionModelFromJson(String str) =>
    List<ServiceSectionModel>.from(
        json.decode(str).map((x) => ServiceSectionModel.fromJson(x)));

String serviceSectionModelToJson(List<ServiceSectionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ServiceSectionModel> serviceSectionModelFromList(
        List<dynamic> listDynamic) =>
    List<ServiceSectionModel>.from(
        listDynamic.map((x) => ServiceSectionModel.fromJson(x)));

class ServiceSectionModel {
  ServiceSectionModel({
    this.id = "",
    this.title = "",
    this.description = "",
    this.interaction = "",
    this.view = "",
    this.date,
    this.source = "",
    this.totalViews = 0,
    this.image,
    this.endpoint,
    this.deprecated = false,
    this.enable = false,
  });

  String id;
  String title;
  String description;
  String interaction;
  String view;
  DateTime? date;
  String source;
  int totalViews;
  ImageServiceSection? image;
  EndPointBaseModel? endpoint;
  bool deprecated;
  bool enable;

  factory ServiceSectionModel.fromJson(Map<String, dynamic> json) =>
      ServiceSectionModel(
        id: json["id"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        interaction: json["interaction"] ?? "",
        view: json["view"] ?? "",
        date: json["date"] == null
            ? DateTime.now()
            : DateTime.parse(json["date"]),
        source: json["source"] ?? "",
        totalViews: json["total_views"] ?? 0,
        image: json["image"] == null
            ? null
            : ImageServiceSection.fromJson(json["image"]),
        endpoint: json["endpoint"] == null
            ? null
            : EndPointBaseModel.fromJson(json["endpoint"]),
        deprecated: json["deprecated"] ?? false,
        enable: json["enable"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "interaction": interaction,
        "view": view,
        "date": date == null
            ? null
            : "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "source": source,
        "total_views": totalViews,
        "image": image?.toJson(),
        "endpoint": endpoint?.toJson(),
        "deprecated": deprecated,
        "enable": enable,
      };
}

class ImageServiceSection {
  ImageServiceSection({
    this.url = "",
    this.thumb = "",
    this.medium = "",
  });

  String url;
  String thumb;
  String medium;

  factory ImageServiceSection.fromJson(Map<String, dynamic> json) =>
      ImageServiceSection(
        url: json["url"],
        thumb: json["thumb"],
        medium: json["medium"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "thumb": thumb,
        "medium": medium,
      };
}
