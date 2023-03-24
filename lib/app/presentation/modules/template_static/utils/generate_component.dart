import 'package:flutter/material.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/presentation/modules/banner/banner_page.dart';
import 'package:utpl_totem/app/presentation/modules/events/events_page.dart';
import 'package:utpl_totem/app/presentation/modules/flickr/flick_page.dart';
import 'package:utpl_totem/app/presentation/modules/graph/graph_page.dart';
import 'package:utpl_totem/app/presentation/modules/investigation/investigation_page.dart';
import 'package:utpl_totem/app/presentation/modules/news/new_page.dart';
import 'package:utpl_totem/app/presentation/modules/observatories/observatories_page.dart';
import 'package:utpl_totem/app/presentation/modules/ranking/ranking_page.dart';
import 'package:utpl_totem/app/presentation/modules/template_static/template_static_controller.dart';
import 'package:utpl_totem/app/presentation/modules/videos/videos_page.dart';
import 'package:utpl_totem/app/presentation/modules/web_component/web_component_page.dart';
import 'package:utpl_totem/app/presentation/modules/youtube_videos/youtube_videos_page.dart';

class GenerateComponent {
  static dynamic generateComponent(
      String type, TemplateStaticController ctrl, TvTemplateBody item, int i) {
    switch (type) {
      case 'link':
        return WebComponentPage(item.link?.url ?? '');
      case "embedded_youtube":
        return VideosPage(item);
        return SizedBox();
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
      case "ranking":
        return const RankingPage();

      case "observatories":
        return const ObservatoriesPage();

      case "indicators":
        return const InvestigationPage();

      default:
        return const SizedBox();
    }
  }
}
