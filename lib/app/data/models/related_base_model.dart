// To parse this JSON data, do
//
//     final relatedBaseModel = relatedBaseModelFromJson(jsonString);

import 'dart:convert';

RelatedBaseModel relatedBaseModelFromJson(String str) =>
    RelatedBaseModel.fromJson(json.decode(str));

String relatedBaseModelToJson(RelatedBaseModel data) =>
    json.encode(data.toJson());

List<RelatedBaseModel> relatedBaseModelFromList(List<dynamic> listDynamic) =>
    List<RelatedBaseModel>.from(
        listDynamic.map((x) => RelatedBaseModel.fromJson(x)));

class RelatedBaseModel {
  RelatedBaseModel({
    this.type = "",
    this.identifier = "",
    this.name = "",
    this.title = "",
    this.approvalUnits = "",
    this.noteQuantitative = "",
    this.noteQualitative = "",
    this.group = "",
    this.state = "",
    this.stateAditional = "",
  });

  String type;
  String identifier;
  String name;
  String title;
  String approvalUnits;
  String noteQuantitative;
  String noteQualitative;
  String group;
  String state;
  String stateAditional;

  factory RelatedBaseModel.fromJson(Map<String, dynamic> json) =>
      RelatedBaseModel(
        type: json["type"] ?? "",
        identifier: json["identifier"] ?? "",
        name: json["name"] ?? "",
        title: json["title"] ?? "",
        approvalUnits: json["approvalUnits"] ?? "",
        noteQuantitative: json["noteQuantitative"] ?? "",
        noteQualitative: json["noteQualitative"] ?? "",
        group: json["group"] ?? "",
        state: json["state"] ?? "",
        stateAditional: json["stateAditional"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "identifier": identifier,
        "name": name,
        "title": title,
        "approvalUnits": approvalUnits,
        "noteQuantitative": noteQuantitative,
        "noteQualitative": noteQualitative,
        "group": group,
        "state": state,
        "stateAditional": stateAditional,
      };
}
