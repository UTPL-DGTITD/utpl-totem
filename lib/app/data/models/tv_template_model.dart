// To parse this JSON data, do
//
//     final tvTemplateModel = tvTemplateModelFromJson(jsonString);

import 'dart:convert';

import 'package:utpl_totem/app/data/models/link_base_model.dart';

TvTemplateModel tvTemplateModelFromJson(String str) =>
    TvTemplateModel.fromJson(json.decode(str));

String tvTemplateModelToJson(TvTemplateModel data) =>
    json.encode(data.toJson());

List<TvTemplateModel> tvTemplateModelFromList(List<dynamic> listDynamic) =>
    List<TvTemplateModel>.from(
        listDynamic.map((x) => TvTemplateModel.fromJson(x)));

// TvTemplateModel

class TvTemplateModel {
  TvTemplateModel({
    this.id = "",
    this.title = "",
    this.description = "",
    this.createdAt = "",
    this.tvTemplateHeader,
  });

  String id;
  String title;
  String description;
  String createdAt;
  TvTemplateHeader? tvTemplateHeader;

  factory TvTemplateModel.fromJson(Map<String, dynamic> json) =>
      TvTemplateModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"],
        tvTemplateHeader: json["tv_template_header"] == null
            ? TvTemplateHeader()
            : TvTemplateHeader.fromJson(json["tv_template_header"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created_at": createdAt,
        "tv_template_header": tvTemplateHeader?.toJson(),
      };
}

class TvTemplateHeader {
  TvTemplateHeader({
    this.id = "",
    this.title = "",
    this.totalRows = 0,
    this.totalColumns = 0,
    this.tvTemplateBodies = const [],
  });

  String id;
  String title;
  double? totalRows;
  int? totalColumns;

  List<TvTemplateBody> tvTemplateBodies;

  factory TvTemplateHeader.fromJson(Map<String, dynamic> json) =>
      TvTemplateHeader(
        id: json["id"],
        title: json["title"],
        totalRows: json["total_rows"],
        totalColumns: json["total_columns"],
        tvTemplateBodies: List<TvTemplateBody>.from(
            json["tv_template_bodies"].map((x) => TvTemplateBody.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "total_rows": totalRows,
        "total_columns": totalColumns,
        "tv_template_bodies":
            List<dynamic>.from(tvTemplateBodies.map((x) => x.toJson())),
      };
}

class TvTemplateBody {
  TvTemplateBody({
    this.title = "",
    this.totalRows = 0,
    this.totalColumns = 0,
    this.orderComponent = 0,
    this.interaction,
    this.embeddedData = "",
    this.link,
    this.flickrData = const [],
    this.graphData = const [],
    this.embeddedYoutube = const [],
  });

  String title;
  double totalRows;
  int totalColumns;
  int orderComponent;
  dynamic interaction;
  String? embeddedData;
  LinkBaseModel? link;
  List<FlickrData> flickrData;
  List<GraphData> graphData;
  List<String> embeddedYoutube;
  // dynamic flickrData;

  factory TvTemplateBody.fromJson(Map<String, dynamic> json) => TvTemplateBody(
        title: json["title"],
        totalRows: json["total_rows"],
        totalColumns: json["total_columns"],
        orderComponent: json["order_component"],
        interaction: json["interaction"],
        embeddedData: json["embedded_data"],
        link:
            json["link"] == null ? null : LinkBaseModel.fromJson(json["link"]),
        flickrData: json["flickr_data"] is String
            ? []
            : List<FlickrData>.from(
                json["flickr_data"].map((x) => FlickrData.fromJson(x))),
        graphData: json["graph_data"] == null
            ? []
            : List<GraphData>.from(
                json["graph_data"].map((x) => GraphData.fromJson(x))),
        embeddedYoutube: json["embedded_youtube"] == null
            ? []
            : List<String>.from(json["embedded_youtube"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "total_rows": totalRows,
        "total_columns": totalColumns,
        "order_component": orderComponent,
        "interaction": interaction,
        "embedded_data": embeddedData,
        "link": link == null ? link : link?.toJson(),
        "flickr_data": List<dynamic>.from(flickrData.map((x) => x.toJson())),
        "graph_data": List<dynamic>.from(graphData.map((x) => x.toJson())),
        "embedded_youtube": List<dynamic>.from(embeddedYoutube.map((x) => x)),

        // "flickr_data": flickrData,
      };
}

class FlickrData {
  FlickrData({
    this.id = "",
    this.secret = "",
    this.server = "",
    this.farm = 0,
    this.title = "",
    this.isprimary = "",
    this.ispublic = 0,
    this.isfriend = 0,
    this.isfamily = 0,
    this.urlM = "",
    this.heightM = 0,
    this.widthM = 0,
  });

  String id;
  String secret;
  String server;
  int farm;
  String title;
  String isprimary;
  int ispublic;
  int isfriend;
  int isfamily;
  String urlM;
  int heightM;
  int widthM;

  factory FlickrData.fromJson(Map<String, dynamic> json) => FlickrData(
        id: json["id"],
        secret: json["secret"],
        server: json["server"],
        farm: json["farm"],
        title: json["title"],
        isprimary: json["isprimary"],
        ispublic: json["ispublic"],
        isfriend: json["isfriend"],
        isfamily: json["isfamily"],
        urlM: json["url_m"],
        heightM: json["height_m"],
        widthM: json["width_m"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "secret": secret,
        "server": server,
        "farm": farm,
        "title": title,
        "isprimary": isprimary,
        "ispublic": ispublic,
        "isfriend": isfriend,
        "isfamily": isfamily,
        "url_m": urlM,
        "height_m": heightM,
        "width_m": widthM,
      };
}

class GraphData {
  GraphData({
    this.title = "",
    this.value = 0,
    this.color = "",
  });

  String title;
  int value;
  String color;

  factory GraphData.fromJson(Map<String, dynamic> json) => GraphData(
        title: json["title"],
        value: json["value"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "color": color,
      };
}
