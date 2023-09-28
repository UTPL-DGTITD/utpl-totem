// To parse this JSON data, do
//
//     final flickrModel = flickrModelFromJson(jsonString);

import 'dart:convert';

FlickrModel flickrModelFromJson(String str) =>
    FlickrModel.fromJson(json.decode(str));

String flickrModelToJson(FlickrModel data) => json.encode(data.toJson());

List<FlickrModel> flickrModelFromList(List<dynamic> listDynamic) =>
    List<FlickrModel>.from(listDynamic.map((x) => FlickrModel.fromJson(x)));

class FlickrModel {
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

  FlickrModel({
    required this.id,
    required this.secret,
    required this.server,
    required this.farm,
    required this.title,
    required this.isprimary,
    required this.ispublic,
    required this.isfriend,
    required this.isfamily,
    required this.urlM,
    required this.heightM,
    required this.widthM,
  });

  factory FlickrModel.fromJson(Map<String, dynamic> json) => FlickrModel(
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
