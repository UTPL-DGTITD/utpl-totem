// To parse this JSON data, do
//
//     final imageBaseModel = imageBaseModelFromJson(jsonString);

import 'dart:convert';

ImageBaseModel imageBaseModelFromJson(String str) =>
    ImageBaseModel.fromJson(json.decode(str));

String imageBaseModelToJson(ImageBaseModel data) => json.encode(data.toJson());

class ImageBaseModel {
  ImageBaseModel({
    this.url = "",
    this.thumb = "",
    this.medium = "",
  });

  String url;
  String thumb;
  String medium;

  factory ImageBaseModel.fromJson(Map<String, dynamic> json) => ImageBaseModel(
        url: json["url"] ?? "",
        thumb: json["thumb"] ?? "",
        medium: json["medium"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "thumb": thumb,
        "medium": medium,
      };
}
