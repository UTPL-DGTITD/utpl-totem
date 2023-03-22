import 'package:utpl_totem/app/data/models/related_base_model.dart';

class Extra {
  Extra({
    this.type = "",
    this.name = "",
    this.data = const [],
  });

  String type;
  String name;
  List<Datum> data;

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        type: json["type"] ?? "",
        name: json["name"] ?? "",
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.identifier = "",
    this.title = "",
    this.description = "",
    this.classroom = "",
    this.type = "",
    this.place = "",
    this.typeSchedule = "",
    this.beginClass = "",
    this.endClass = "",
    this.day = "",
    this.location = "",
    this.relation = const [],
  });

  String identifier;
  String title;
  String description;
  String classroom;
  String type;
  String place;
  String typeSchedule;
  String beginClass;
  String endClass;
  String day;
  String location;
  List<RelatedBaseModel> relation;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        identifier: json["identifier"] ?? "",
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        classroom: json["classroom"] ?? "",
        type: json["type"] ?? "",
        place: json["place"] ?? "",
        typeSchedule: json["typeSchedule"] ?? "",
        beginClass: json["beginClass"] ?? "",
        endClass: json["endClass"] ?? "",
        day: json["day"] ?? "",
        location: json["location"] ?? "",
        relation: json["relation"] == null
            ? []
            : List<RelatedBaseModel>.from(
                json["relation"].map((x) => RelatedBaseModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "title": title,
        "description": description,
        "classroom": classroom,
        "type": type,
        "place": place,
        "typeSchedule": typeSchedule,
        "beginClass": beginClass,
        "endClass": endClass,
        "day": day,
        "location": location,
        "relation": List<dynamic>.from(relation.map((x) => x.toJson())),
      };
}
