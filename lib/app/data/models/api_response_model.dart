// To parse this JSON data, do
//
//     final responseApiModel = responseApiModelFromJson(jsonString);

import 'dart:convert';

ApiResponseModel responseApiModelFromJson(String str) =>
    ApiResponseModel.fromJson(json.decode(str));

String responseApiModelToJson(ApiResponseModel data) =>
    json.encode(data.toJson());

class ApiResponseModel {
  ApiResponseModel({
    this.total = 0,
    this.view,
    this.message = "",
    this.page = 0,
    this.paginator = 0,
    this.status = 0,
    this.data,
  });

  int total;
  String? view;
  String message;
  int page;
  int paginator;
  int status;
  dynamic data;

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) =>
      ApiResponseModel(
        total: json["total"] ?? 0,
        view: json["view"],
        message: json["message"] ?? "",
        page: json["page"] ?? 0,
        paginator: json["paginator"] ?? 0,
        status: json["status"] ?? 0,
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "view": view,
        "message": message,
        "page": page,
        "paginator": paginator,
        "status": status,
        "data": data,
      };
}
