import 'package:bot_toast/bot_toast.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/main_binding.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/app_theme.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

import 'package:wakelock/wakelock.dart';
import 'package:window_manager/window_manager.dart';

import 'app/controllers/main_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    // DESCOMENTAR PARA PRODUCCION
    fullScreen: true,
    // DESCOMENTAR PARA PROBAR DE MANERA LOCAL   size: Size(385, 674),
    //size: Size(385, 674),
    //center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  DartVLC.initialize();

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
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: mainCtrl.navigatorKey,
        title: 'UTPL Totem',
        themeMode: ThemeMode.light, //ThemeService().getThemeMode(),
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
      onTap: () {
        ToolsHelper.logger.v('HUBO CONTACTO');
      },
    );
  }
}
