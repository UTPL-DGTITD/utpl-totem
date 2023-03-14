// To parse this JSON data, do
//
//     final observatoryDetailModel = observatoryDetailModelFromJson(jsonString);

import 'dart:convert';

ObservatoryDetailModel observatoryDetailModelFromJson(String str) =>
    ObservatoryDetailModel.fromJson(json.decode(str));

String observatoryDetailModelToJson(ObservatoryDetailModel data) =>
    json.encode(data.toJson());

class ObservatoryDetailModel {
  ObservatoryDetailModel({
    this.status = '',
    this.description = '',
    this.image = '',
    this.equipo = '',
    this.members = const [],
    this.date = '',
    this.type = '',
    this.id = '',
    this.name = '',
  });

  String status;
  String description;
  String image;
  String equipo;
  List<Member> members;
  String date;
  String type;
  String id;
  String name;

  factory ObservatoryDetailModel.fromJson(Map<String, dynamic> json) =>
      ObservatoryDetailModel(
        status: json["status"],
        description: json["description"],
        image: json["image"] ?? '',
        equipo: json["equipo"] ?? '',
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
        date: json["date"],
        type: json["type"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "description": description,
        "image": image,
        "equipo": equipo,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
        "date": date,
        "type": type,
        "id": id,
        "name": name,
      };
}

class Member {
  Member({
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.role,
    required this.identifier,
    required this.type,
    required this.email,
  });

  String name;
  String firstName;
  String lastName;
  String image;
  String role;
  String identifier;
  String type;
  String email;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        name: json["name"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        image: json["image"],
        role: json["role"],
        identifier: json["identifier"],
        type: json["type"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
        "role": role,
        "identifier": identifier,
        "type": type,
        "email": email,
      };
}
