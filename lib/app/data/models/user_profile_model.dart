// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

import 'package:utpl_totem/app/data/models/end_point_base_model.dart';
import 'package:utpl_totem/app/data/models/image_base_model.dart';
import 'package:utpl_totem/app/data/models/roles_model.dart';

UserProfileModel userProfileModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

List<UserProfileModel> userProfileModelFromList(List<dynamic> listDynamic) =>
    List<UserProfileModel>.from(
        listDynamic.map((x) => UserProfileModel.fromJson(x)));

String userProfileModelToJson(UserProfileModel data) =>
    json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    this.id = "",
    this.givenName = "",
    this.surname = "",
    this.city = "",
    this.displayName = "",
    this.employeeId = "",
    this.jobTitle = "",
    this.mail = "",
    this.mailNickname = "",
    this.personalQr = "",
    this.qrDecode = "",
    this.roles = const [],
    this.endpoint,
    this.interaction = "",
    this.image,
  });

  String id;
  String givenName;
  String surname;
  String city;
  String displayName;

  /// User NUI
  String employeeId;
  String jobTitle;
  String mail;
  String mailNickname;
  String personalQr;
  String qrDecode;
  List<RolesModel> roles;
  EndPointBaseModel? endpoint;
  String interaction;
  ImageBaseModel? image;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        id: json["id"] ?? "",
        givenName: json["givenName"] ?? "",
        surname: json["surname"] ?? "",
        city: json["city"] ?? "",
        displayName: json["displayName"] ?? "",
        employeeId: json["employeeId"] ?? "",
        jobTitle: json["jobTitle"] ?? "",
        mail: json["mail"] ?? "",
        mailNickname: json["mailNickname"] ?? "",
        personalQr: json["personalQR"] ?? "",
        qrDecode: json["QRDecode"] ?? "",
        roles: json["roles"] == null
            ? []
            : List<RolesModel>.from(
                json["roles"].map((x) => RolesModel.fromJson(x))),
        endpoint: json["endpoint"] == null
            ? null
            : EndPointBaseModel.fromJson(json["endpoint"]),
        interaction: json["interaction"] ?? "",
        image: json["image"] == null
            ? null
            : ImageBaseModel.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "givenName": givenName,
        "surname": surname,
        "city": city,
        "displayName": displayName,
        "employeeId": employeeId,
        "jobTitle": jobTitle,
        "mail": mail,
        "mailNickname": mailNickname,
        "personalQR": personalQr,
        "QRDecode": qrDecode,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "endpoint": endpoint?.toJson(),
        "interaction": interaction,
        "image": image == null ? image : image?.toJson(),
      };
}
