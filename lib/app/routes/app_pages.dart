import 'package:get/get.dart';
import 'package:utpl_totem/app/main_binding.dart';
import 'package:utpl_totem/app/presentation/modules/events/events_binding.dart';
import 'package:utpl_totem/app/presentation/modules/events/events_page.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_binding.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_page.dart';
import 'package:utpl_totem/app/presentation/modules/news/new_page.dart';
import 'package:utpl_totem/app/presentation/modules/news/news_binding.dart';
import 'package:utpl_totem/app/presentation/modules/observatories/observatory_detail/observatory_detail_binding.dart';
import 'package:utpl_totem/app/presentation/modules/observatories/observatory_detail/observatory_detail_page.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/schedule_binding.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/schedule_page.dart';
import 'package:utpl_totem/app/presentation/modules/screen_protector/screen_protector_binding.dart';
import 'package:utpl_totem/app/presentation/modules/screen_protector/screen_protector_page.dart';
import 'package:utpl_totem/app/presentation/modules/splash_screen/splash_screen_binding.dart';
import 'package:utpl_totem/app/presentation/modules/splash_screen/splash_screen_page.dart';
import 'package:utpl_totem/app/presentation/modules/template_offline/template_offline_binding.dart';
import 'package:utpl_totem/app/presentation/modules/template_offline/template_offline_page.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_binding.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_page.dart';
import 'package:utpl_totem/app/presentation/modules/validate/validate_binding.dart';
import 'package:utpl_totem/app/presentation/modules/validate/validate_page.dart';
import 'package:utpl_totem/app/presentation/modules/web/web_binding.dart';
import 'package:utpl_totem/app/presentation/modules/web/web_page.dart';

part './app_routes.dart';

class AppPages {
  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: Routes.splash_screen,
      page: () => const SplashScreenPage(),
      bindings: [
        MainBinding(),
        SplashScreenBinding(),
      ],
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      bindings: [
        MainBinding(),
        HomeBinding(),
      ],
    ),
    GetPage(
      name: Routes.web,
      page: () => const WebPage(),
      bindings: [
        MainBinding(),
        WebBinding(),
      ],
    ),
    GetPage(
      name: Routes.validate,
      page: () => const ValidatePage(),
      bindings: [
        MainBinding(),
        ValidateBinding(),
      ],
    ),
    GetPage(
      name: Routes.news,
      page: () => const NewsPage(),
      bindings: [
        MainBinding(),
        NewsBinding(),
      ],
    ),
    GetPage(
      name: Routes.events,
      page: () => const EventsPage(),
      bindings: [
        MainBinding(),
        EventsBinding(),
      ],
    ),
    GetPage(
      name: Routes.template_offline,
      page: () => const TemplateOfflinePage(),
      bindings: [
        MainBinding(),
        TemplateOfflineBinding(),
      ],
    ),
    GetPage(
      name: Routes.observatory_detail,
      page: () => const ObservatoryDetailPage(),
      bindings: [
        MainBinding(),
        ObservatoryDetailBinding(),
      ],
    ),
    GetPage(
      name: Routes.screen_protector,
      page: () => const ScreenProtectorPage(),
      bindings: [
        MainBinding(),
        ScreenProtectorBinding(),
      ],
    ),
    GetPage(
      name: Routes.schedule,
      page: () => const SchedulePage(),
      bindings: [
        MainBinding(),
        ScheduleBinding(),
      ],
    ),
  ];
}
