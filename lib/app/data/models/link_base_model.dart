// To parse this JSON data, do
//
//     final linkBaseModel = linkBaseModelFromJson(jsonString);

import 'dart:convert';

LinkBaseModel linkBaseModelFromJson(String str) =>
    LinkBaseModel.fromJson(json.decode(str));

String linkBaseModelToJson(LinkBaseModel data) => json.encode(data.toJson());

class LinkBaseModel {
  LinkBaseModel({
    this.url = "",
    this.target = "",
  });

  String url;
  String target;

  factory LinkBaseModel.fromJson(Map<String, dynamic> json) => LinkBaseModel(
        url: json["url"] ?? "",
        target: json["target"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "target": target,
      };
}
