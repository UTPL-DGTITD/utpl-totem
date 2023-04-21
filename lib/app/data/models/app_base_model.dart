// To parse this JSON data, do
//
//     final appBaseModel = appBaseModelFromJson(jsonString);

import 'dart:convert';

AppBaseModel appBaseModelFromJson(String str) =>
    AppBaseModel.fromJson(json.decode(str));

String appBaseModelToJson(AppBaseModel data) => json.encode(data.toJson());

class AppBaseModel {
  AppBaseModel({
    this.appStoreUrl = "",
    this.playStoreUrl = "",
    this.huaweiGalleryUrl = "",
  });

  String appStoreUrl;
  String playStoreUrl;
  String huaweiGalleryUrl;

  factory AppBaseModel.fromJson(Map<String, dynamic> json) => AppBaseModel(
        appStoreUrl: json["app_store_url"] ?? "",
        playStoreUrl: json["play_store_url"] ?? "",
        huaweiGalleryUrl: json["huawei_gallery_url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "app_store_url": appStoreUrl,
        "play_store_url": playStoreUrl,
        "huawei_gallery_url": huaweiGalleryUrl,
      };
}
