import 'package:flutter/material.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/presentation/modules/banner/banner_page.dart';
import 'package:utpl_totem/app/presentation/modules/events/events_page.dart';
import 'package:utpl_totem/app/presentation/modules/flickr/flick_page.dart';
import 'package:utpl_totem/app/presentation/modules/graph/graph_page.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_controller.dart';
import 'package:utpl_totem/app/presentation/modules/news/new_page.dart';
import 'package:utpl_totem/app/presentation/modules/web_component/web_component_page.dart';
import 'package:utpl_totem/app/presentation/modules/youtube_videos/youtube_videos_page.dart';

class GenerateComponent {
  static dynamic generateComponent(
      String type, HomeController ctrl, TvTemplateBody item, int i) {
    switch (type) {
      case 'link':
        return WebComponentPage(item);
      case "embedded_youtube":
        return YoutubeVideosPage(item);
      // return SizedBox();
      case "banner":
        return const BannerPage();
      case "graph":
        return GraphPage(item);
      case "embedded_flickr":
        return FlickrPage(item);
      case "news":
        return const NewsPage();
      case "events":
        return const EventsPage();
      default:
        return const SizedBox();
    }
  }
}
