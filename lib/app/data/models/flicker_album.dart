// To parse this JSON data, do
//
//     final flickerAlbum = flickerAlbumFromJson(jsonString);

import 'dart:convert';

FlickerAlbum flickerAlbumFromJson(String str) =>
    FlickerAlbum.fromJson(json.decode(str));

String flickerAlbumToJson(FlickerAlbum data) => json.encode(data.toJson());

List<FlickerAlbum> flickerAlbumModelFromList(List<dynamic> listDynamic) =>
    List<FlickerAlbum>.from(listDynamic.map((x) => FlickerAlbum.fromJson(x)));

class FlickerAlbum {
  String id;
  String owner;
  String username;
  String primary;
  String secret;
  String server;
  int farm;
  String countViews;
  String countComments;
  int countPhotos;
  int countVideos;
  Description? title;
  Description? description;
  int canComment;
  String dateCreate;
  String dateUpdate;
  int photos;
  int videos;
  int visibilityCanSeeSet;
  int needsInterstitial;

  FlickerAlbum({
    this.id = '',
    this.owner = '',
    this.username = '',
    this.primary = '',
    this.secret = '',
    this.server = '',
    this.farm = 0,
    this.countViews = '',
    this.countComments = '',
    this.countPhotos = 0,
    this.countVideos = 0,
    this.title,
    this.description,
    this.canComment = 0,
    this.dateCreate = '',
    this.dateUpdate = '',
    this.photos = 0,
    this.videos = 0,
    this.visibilityCanSeeSet = 0,
    this.needsInterstitial = 0,
  });

  factory FlickerAlbum.fromJson(Map<String, dynamic> json) => FlickerAlbum(
        id: json["id"],
        owner: json["owner"],
        username: json["username"],
        primary: json["primary"],
        secret: json["secret"],
        server: json["server"],
        farm: json["farm"],
        countViews: json["count_views"],
        countComments: json["count_comments"],
        countPhotos: json["count_photos"],
        countVideos: json["count_videos"],
        title:
            json["title"] == null ? null : Description.fromJson(json["title"]),
        description: json["description"] == null
            ? null
            : Description.fromJson(json["description"]),
        canComment: json["can_comment"],
        dateCreate: json["date_create"],
        dateUpdate: json["date_update"],
        photos: json["photos"],
        videos: json["videos"],
        visibilityCanSeeSet: json["visibility_can_see_set"],
        needsInterstitial: json["needs_interstitial"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "username": username,
        "primary": primary,
        "secret": secret,
        "server": server,
        "farm": farm,
        "count_views": countViews,
        "count_comments": countComments,
        "count_photos": countPhotos,
        "count_videos": countVideos,
        "title": title?.toJson(),
        "description": description?.toJson(),
        "can_comment": canComment,
        "date_create": dateCreate,
        "date_update": dateUpdate,
        "photos": photos,
        "videos": videos,
        "visibility_can_see_set": visibilityCanSeeSet,
        "needs_interstitial": needsInterstitial,
      };
}

class Description {
  String content;

  Description({
    this.content = '',
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        content: json["_content"],
      );

  Map<String, dynamic> toJson() => {
        "_content": content,
      };
}
