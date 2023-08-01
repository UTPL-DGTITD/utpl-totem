// To parse this JSON data, do
//
//     final flickerVideoImgResponseModel = flickerVideoImgResponseModelFromJson(jsonString);

import 'dart:convert';

FlickerVideoImgResponseModel flickerVideoImgResponseModelFromJson(String str) =>
    FlickerVideoImgResponseModel.fromJson(json.decode(str));

String flickerVideoImgResponseModelToJson(FlickerVideoImgResponseModel data) =>
    json.encode(data.toJson());
List<FlickerVideoImgResponseModel> flickerVideoImgResponseModelFromList(
        List<dynamic> listDynamic) =>
    List<FlickerVideoImgResponseModel>.from(
        listDynamic.map((x) => FlickerVideoImgResponseModel.fromJson(x)));

class FlickerVideoImgResponseModel {
  String? label;
  dynamic? width;
  dynamic? height;
  String? source;
  String? url;
  String? media;

  FlickerVideoImgResponseModel({
    this.label = '',
    this.width = '',
    this.height = '',
    this.source = '',
    this.url = '',
    this.media = '',
  });

  factory FlickerVideoImgResponseModel.fromJson(Map<String, dynamic> json) =>
      FlickerVideoImgResponseModel(
        label: json["label"],
        width: json["width"] ?? '',
        height: json["height"] ?? '',
        source: json["source"],
        url: json["url"],
        media: json["media"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "width": width,
        "height": height,
        "source": source,
        "url": url,
        "media": media,
      };
}
