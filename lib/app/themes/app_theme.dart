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
        headline3: ThemeData.light().textTheme.headline3?.copyWith(
              color: LightSchema.lightColor,
            ),
        headline5: ThemeData.light().textTheme.headline5?.copyWith(
              color: LightSchema.primaryColor,
            ),
        headline6: ThemeData.light().textTheme.headline6?.copyWith(
              color: LightSchema.darkColorDark,
            ),
        bodyText1: ThemeData.light().textTheme.bodyText1?.copyWith(
              color: LightSchema.darkColor,
            ),
        bodyText2: ThemeData.light().textTheme.bodyText2?.copyWith(
              color: LightSchema.mediumColor,
            ),
        subtitle1: ThemeData.light().textTheme.subtitle1?.copyWith(
              color: LightSchema.darkColorLight,
            ),
        subtitle2: ThemeData.light().textTheme.subtitle2?.copyWith(
              color: LightSchema.mediumColorDark,
            ),
        caption: ThemeData.light().textTheme.caption?.copyWith(
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
