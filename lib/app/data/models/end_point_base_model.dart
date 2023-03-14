// To parse this JSON data, do
//
//     final endPointBaseModel = endPointBaseModelFromJson(jsonString);

import 'dart:convert';

EndPointBaseModel endPointBaseModelFromJson(String str) =>
    EndPointBaseModel.fromJson(json.decode(str));

String endPointBaseModelToJson(EndPointBaseModel data) =>
    json.encode(data.toJson());

class EndPointBaseModel {
  EndPointBaseModel({
    this.urlBase = "",
    this.urlPath = "",
    this.version = "",
    this.method = "",
    this.authentication = false,
    this.headers,
    this.pathVariables = const [],
    this.queryParams = const [],
    this.gui,
  });

  String urlBase;
  String urlPath;
  String version;
  String method;
  bool authentication;
  Map<String, dynamic>? headers;
  List<PathVariable> pathVariables;
  List<PathVariable> queryParams;
  Gui? gui;

  factory EndPointBaseModel.fromJson(Map<String, dynamic> json) =>
      EndPointBaseModel(
        urlBase: json["urlBase"] ?? "",
        urlPath: json["urlPath"] ?? "",
        version: json["version"] ?? "",
        method: json["method"] ?? "",
        authentication: json["authentication"] is String
            ? json["authentication"] == "true"
                ? true
                : false
            : json["authentication"] ?? false,
        headers: json["headers"] == null
            ? null
            : Map.from(json["headers"])
                .map((k, v) => MapEntry<String, dynamic>(k, v)),
        pathVariables: json["path_variables"] == null
            ? []
            : List<PathVariable>.from(
                json["path_variables"].map((x) => PathVariable.fromJson(x))),
        queryParams: json["query_params"] == null
            ? []
            : List<PathVariable>.from(
                json["query_params"].map((x) => PathVariable.fromJson(x))),
        gui: json["gui"] == null
            ? Gui()
            : json["gui"] == ""
                ? Gui()
                : Gui.fromJson(json["gui"]),
      );

  Map<String, dynamic> toJson() => {
        "urlBase": urlBase,
        "urlPath": urlPath,
        "version": version,
        "method": method,
        "authentication": authentication,
        "headers": headers,
        "path_variables":
            List<dynamic>.from(pathVariables.map((x) => x.toJson())),
        "query_params": List<dynamic>.from(queryParams.map((x) => x.toJson())),
        "gui": gui?.toJson(),
      };
}

class PathVariable {
  PathVariable({
    this.name = "",
    this.value,
    this.type = "",
    this.defaultValue = "",
  });

  String name;
  String? value;
  String type;
  String defaultValue;

  factory PathVariable.fromJson(Map<String, dynamic> json) => PathVariable(
        name: json["name"] ?? "",
        value: json["value"],
        type: json["type"] ?? "",
        defaultValue: json["defaultValue"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "type": type,
        "defaultValue": defaultValue,
      };
}

class Gui {
  Gui({
    this.layout = "",
    this.cardtype = "",
  });

  String layout;
  String cardtype;

  factory Gui.fromJson(Map<String, dynamic> json) => Gui(
        layout: json["layout"] ?? "",
        cardtype: json["cardtype"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "layout": layout,
        "cardtype": cardtype,
      };
}
