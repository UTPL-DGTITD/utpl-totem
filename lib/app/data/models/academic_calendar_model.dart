// To parse this JSON data, do
//
//     final activityCalendarModel = activityCalendarModelFromJson(jsonString);

import 'dart:convert';

List<List<List<ActivityCalendarModel>>> activityCalendarModelFromJson(
        String str) =>
    List<List<List<ActivityCalendarModel>>>.from(json.decode(str).map((x) =>
        List<List<ActivityCalendarModel>>.from(x.map((x) =>
            List<ActivityCalendarModel>.from(
                x.map((x) => ActivityCalendarModel.fromJson(x)))))));

String activityCalendarModelToJson(
        List<List<List<ActivityCalendarModel>>> data) =>
    json.encode(List<dynamic>.from(data.map((x) => List<dynamic>.from(
        x.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))))));

List<List<List<ActivityCalendarModel>>> activityCalendarModelFromList(
        List<dynamic> listDynamic) =>
    List<List<List<ActivityCalendarModel>>>.from(listDynamic.map((x) =>
        List<List<ActivityCalendarModel>>.from(x.map((x) =>
            List<ActivityCalendarModel>.from(
                x.map((x) => ActivityCalendarModel.fromJson(x)))))));

class ActivityCalendarModel {
  ActivityCalendarModel({
    this.description = '',
    this.academicCalendarCategoryId = '',
    this.startDate,
    this.endDate,
    this.title = '',
    this.id = '',
    this.academicProgram = '',
  });

  String description;
  String academicCalendarCategoryId;
  DateTime? startDate;
  DateTime? endDate;
  String title;
  String id;
  String academicProgram;

  factory ActivityCalendarModel.fromJson(Map<String, dynamic> json) =>
      ActivityCalendarModel(
        description: json["description"],
        academicCalendarCategoryId: json["academic_calendar_category_id"],
        // startDate: DateTime.parse(json["start_date"]),
        // endDate: DateTime.parse(json["end_date"]),
        startDate: json["start_date"] == null
            ? DateTime.now()
            : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null
            ? DateTime.now()
            : DateTime.parse(json["end_date"]),

        title: json["title"],
        id: json["id"],
        academicProgram: json["academic_program"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "academic_calendar_category_id": academicCalendarCategoryId,
        "start_date": startDate == null
            ? null
            : "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "end_date": endDate == null
            ? null
            : "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "title": title,
        "id": id,
        "academic_program": academicProgram,
      };
}
