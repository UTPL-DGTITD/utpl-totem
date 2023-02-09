import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/services/theme_service.dart';
import 'package:utpl_totem/app/main_binding.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/app_theme.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

import 'package:wakelock/wakelock.dart';

import 'app/controllers/main_controller.dart';

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final mainCtrl = Get.put<MainController>(MainController());
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return GestureDetector(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: mainCtrl.navigatorKey,
        title: 'UTPL Totem',
        themeMode: ThemeService().getThemeMode(),
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        initialRoute: Routes.splash_screen,
        getPages: AppPages.routes,
        initialBinding: MainBinding(),
        // onUnknownRoute: (settings) => MaterialPageRoute(
        //   builder: (context) => UndefinedRoutePage(
        //     name: settings.name ?? 'Undefined',
        //   ),
        // ),
      ),
      onTap: () => ToolsHelper.hideKeyboard(context),
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
