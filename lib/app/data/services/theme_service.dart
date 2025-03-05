import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

enum ThemeName { dark, light, system }

class ThemeService {
  final _getStorage = GetStorage();
  final _darkThemeKey = 'isDarkTheme';

  void saveThemeData(ThemeName mode) {
    _getStorage.write(_darkThemeKey, mode.name);
    ToolsHelper.logger.v("mode", error: mode.name);
  }

  ThemeName isSavedDarkMode() {
    var theme = _getStorage.read(_darkThemeKey) ?? ThemeName.system.name;
    switch (theme) {
      case "dark":
        return ThemeName.dark;
      case "light":
        return ThemeName.light;
      default:
        return ThemeName.system;
    }
  }

  ThemeMode getThemeMode() {
    var theme = isSavedDarkMode();
    switch (theme.name) {
      case "dark":
        return ThemeMode.dark;
      case "light":
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  void changeCustomTheme(ThemeName mode) {
    switch (mode.name) {
      case "dark":
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case "light":
        Get.changeThemeMode(ThemeMode.light);
        Get.forceAppUpdate();
        break;
      default:
        Get.changeThemeMode(ThemeMode.system);
        Get.forceAppUpdate();
        break;
    }
    Future.delayed(0.5.seconds).then((value) {
      Get.forceAppUpdate();
    });

    saveThemeData(mode);
  }
}
