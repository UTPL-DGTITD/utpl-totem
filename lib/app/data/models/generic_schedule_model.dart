// To parse this JSON data, do
//
//     final genericScheduleModel = genericScheduleModelFromJson(jsonString);

import 'dart:convert';

import 'package:utpl_totem/app/data/models/extra_base_model.dart';

GenericScheduleModel genericScheduleModelFromJson(String str) =>
    GenericScheduleModel.fromJson(json.decode(str));

List<GenericScheduleModel> genericScheduleModelFromList(
        List<dynamic> listDynamic) =>
    List<GenericScheduleModel>.from(
        listDynamic.map((x) => GenericScheduleModel.fromJson(x)));

String genericScheduleModelToJson(GenericScheduleModel data) =>
    json.encode(data.toJson());

class GenericScheduleModel {
  GenericScheduleModel({
    this.title = "",
    this.description = "",
    this.authors = const [],
    this.category = "",
    this.date = "",
    this.image = "",
    this.video = "",
    this.extras = const [],
  });

  String title;
  String description;
  List<dynamic> authors;
  String category;
  String date;
  String image;
  String video;
  List<Extra> extras;

  factory GenericScheduleModel.fromJson(Map<String, dynamic> json) =>
      GenericScheduleModel(
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        authors: json["authors"] == null
            ? []
            : List<dynamic>.from(json["authors"].map((x) => x)),
        category: json["category"] ?? "",
        date: json["date"] ?? "",
        image: json["image"] ?? "",
        video: json["video"] ?? "",
        extras: json["extras"] == null
            ? []
            : List<Extra>.from(json["extras"].map((x) => Extra.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "authors": List<dynamic>.from(authors.map((x) => x)),
        "category": category,
        "date": date,
        "image": image,
        "video": video,
        "extras": List<dynamic>.from(extras.map((x) => x.toJson())),
      };
}
