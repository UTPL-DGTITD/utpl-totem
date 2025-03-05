import 'package:flutter/material.dart';
import 'package:utpl_totem_oficial/app/data/models/tv_template_model.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/banner/banner_page.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/events/events_page.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/image/image_page.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/investigation/investigation_page.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/news/new_page.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/home/home_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/observatories/observatories_page.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/ranking/ranking_page.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/videos/videos_page.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/web_component/web_component_page.dart';

class GenerateComponent {
  static dynamic generateComponent(
      String type, HomeController ctrl, TvTemplateBody item, int i) {
    switch (type) {
      case 'link':
        return WebComponentPage(item.link?.url ?? '');
      case "embedded_youtube":
        return VideosPage(item);
      case "banner":
        //return SizedBox();
        return const BannerPage();
      case "news":
        return const NewsPage();
      case "events":
        return const EventsPage();
      case "ranking":
        //return SizedBox();
        return const RankingPage();
      case "observatories":
        //return SizedBox();
        return const ObservatoriesPage();
      case "indicators":
        //return SizedBox();
        return const InvestigationPage();
      case "image":
        //return VideosPage(item);
        return ImagePage(item);
      default:
        return const SizedBox();
    }
  }
}
