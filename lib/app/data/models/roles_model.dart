// To parse this JSON data, do
//
//     final rolesModel = rolesModelFromJson(jsonString);

import 'dart:convert';

RolesModel rolesModelFromJson(String str) =>
    RolesModel.fromJson(json.decode(str));

List<RolesModel> rolesModelListFromJson(String str) =>
    List<RolesModel>.from(json.decode(str).map((x) => RolesModel.fromJson(x)));

List<RolesModel> rolesModelFromList(List<dynamic> listDynamic) =>
    List<RolesModel>.from(listDynamic.map((x) => RolesModel.fromJson(x)));

String rolesModelListToJson(List<RolesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String rolesModelToJson(RolesModel data) => json.encode(data.toJson());

class RolesModel {
  RolesModel({
    this.code = "",
    this.name = "",
    this.alias = "",
    this.priority = 0,
    this.programs = const [],
  });

  String code;
  String name;
  String alias;
  int priority;
  List<Program> programs;

  factory RolesModel.fromJson(Map<String, dynamic> json) => RolesModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        alias: json["alias"] ?? "",
        priority: json["priority"] ?? 0,
        programs: json["programs"] == null
            ? []
            : List<Program>.from(
                json["programs"].map((x) => Program.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "alias": alias,
        "priority": priority,
        "programs": List<dynamic>.from(programs.map((x) => x.toJson())),
      };
}

class Program {
  Program({
    this.name = "",
    this.modality = "",
  });

  String name;
  String modality;

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        name: json["name"] ?? "",
        modality: json["modality"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "modality": modality,
      };
}
