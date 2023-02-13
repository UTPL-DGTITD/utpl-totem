import 'package:get/get.dart';
import 'package:utpl_totem/app/main_binding.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_binding.dart';
import 'package:utpl_totem/app/presentation/modules/home/home_page.dart';
import 'package:utpl_totem/app/presentation/modules/splash_screen/splash_screen_binding.dart';
import 'package:utpl_totem/app/presentation/modules/splash_screen/splash_screen_page.dart';
import 'package:utpl_totem/app/presentation/modules/template_offline/template_offline_binding.dart';
import 'package:utpl_totem/app/presentation/modules/template_offline/template_offline_page.dart';
import 'package:utpl_totem/app/presentation/modules/template_static/template_static_binding.dart';
import 'package:utpl_totem/app/presentation/modules/template_static/template_static_page.dart';
import 'package:utpl_totem/app/presentation/modules/template_static_2/template_static_binding.dart';
import 'package:utpl_totem/app/presentation/modules/template_static_2/template_static_page.dart';
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
      name: Routes.template_offline,
      page: () => const TemplateOfflinePage(),
      bindings: [
        MainBinding(),
        TemplateOfflineBinding(),
      ],
    ),
    GetPage(
      name: Routes.template_static,
      page: () => const TemplateStaticPage(),
      bindings: [
        MainBinding(),
        TemplateStaticBinding(),
      ],
    ),
    GetPage(
      name: Routes.template_static_2,
      page: () => const TemplateStaticPage2(),
      bindings: [
        MainBinding(),
        TemplateStaticBinding2(),
      ],
    ),
  ];
}
