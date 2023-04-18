import 'package:flutter/material.dart';
part './color_theme.dart';

final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  canvasColor: const Color(0xFFF5F6F9),
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: LightSchema.primaryColor,
        secondary: LightSchema.secondaryColor,
        onSecondary: Colors.black,
        secondaryContainer: LightSchema.secondaryColorLight,
        tertiary: LightSchema.tertiaryColor,
        onTertiary: LightSchema.lightColorLight,
        tertiaryContainer: LightSchema.tertiaryColorLight,
        primaryContainer: LightSchema.lightColorDark,
      ),
  textTheme: ThemeData.light().textTheme.copyWith(
        displaySmall: ThemeData.light().textTheme.displaySmall?.copyWith(
              color: LightSchema.lightColor,
            ),
        headlineSmall: ThemeData.light().textTheme.headlineSmall?.copyWith(
              color: LightSchema.primaryColor,
            ),
        titleLarge: ThemeData.light().textTheme.titleLarge?.copyWith(
              color: LightSchema.darkColorDark,
            ),
        bodyMedium: ThemeData.light().textTheme.bodyMedium?.copyWith(
              color: LightSchema.darkColor,
            ),
        titleMedium: ThemeData.light().textTheme.titleMedium?.copyWith(
              color: LightSchema.darkColorLight,
            ),
        titleSmall: ThemeData.light().textTheme.titleSmall?.copyWith(
              color: LightSchema.mediumColorDark,
            ),
        bodySmall: ThemeData.light().textTheme.bodySmall?.copyWith(
              color: LightSchema.mediumColor,
            ),
      ),
  appBarTheme: ThemeData.light().appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: LightSchema.lightColor,
        foregroundColor: LightSchema.darkColor,
      ),
  tabBarTheme: ThemeData.light().tabBarTheme.copyWith(
        labelColor: LightSchema.darkColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelColor: LightSchema.mediumColor,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3.0,
            color: LightSchema.tertiaryColor,
          ),
          insets: EdgeInsets.symmetric(horizontal: 52.0),
        ),
      ),
  indicatorColor: LightSchema.tertiaryColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: LightSchema.primaryColorDark,

        /// Icon size for
        /// UtplCustom: responsive.ip(2) | size: 20
        /// Icons: responsive.ip(2.5) | size: 25
      ),
  checkboxTheme: ThemeData.light().checkboxTheme.copyWith(
        fillColor: MaterialStateProperty.all(LightSchema.primaryColor),
      ),
);

final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  canvasColor: const Color(0xFF000000),
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: DarkSchema.tertiaryColor,
        secondary: DarkSchema.tertiaryColor,
        onSecondary: Colors.black,
        secondaryContainer: DarkSchema.secondaryColorLight,
        tertiary: DarkSchema.tertiaryColor,
        onTertiary: DarkSchema.lightColorLight,
        tertiaryContainer: DarkSchema.tertiaryColorLight,
        primaryContainer: DarkSchema.lightColorDark,
      ),
  appBarTheme: ThemeData.dark().appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: const Color(0xFF000000),
        foregroundColor: LightSchema.lightColor,
      ),
  tabBarTheme: ThemeData.dark().tabBarTheme.copyWith(
        labelColor: LightSchema.lightColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelColor: LightSchema.mediumColor,
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3.0,
            color: LightSchema.tertiaryColor,
          ),
          insets: EdgeInsets.symmetric(horizontal: 52.0),
        ),
      ),
  indicatorColor: DarkSchema.tertiaryColor,
  cardColor: const Color(0xFF1C1C1C),
);
