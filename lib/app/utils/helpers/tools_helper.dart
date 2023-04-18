import 'dart:io' as io;

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:url_launcher/url_launcher_string.dart';
//import 'package:store_redirect/store_redirect.dart';
import 'package:timeago/timeago.dart' as time_ago;
import 'package:url_launcher/url_launcher.dart';
//import 'package:aad_oauth/model/config.dart';
//import 'package:aad_oauth/aad_oauth.dart';
import 'package:utpl_totem/app/controllers/main_controller.dart';
import 'package:utpl_totem/app/data/enviroment.dart';
//import 'package:utpl_totem/app/data/enviroment.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';

import 'package:logger/logger.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';

class ToolsHelper {
  static final _toastUtilInterface = Get.put(ToastService());
  static final _mainCtrl = Get.put(MainController());

  static Logger get logger => Logger(
        printer: PrettyPrinter(
          colors: io.stdout.supportsAnsiEscapes,
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 80,
        ),
      );

  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.requestFocus(FocusNode());
    }
  }

  static Future<void> openUrl({required String url}) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      try {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } catch (error) {
        _toastUtilInterface.presentErrorToast(
          text: 'No se puede abrir la url: $url',
        );
      }
    }
  }

  static Future<void> openPhone({required String phoneNumber}) async {
    var phoneUrl = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    } else {
      try {
        await launchUrl(phoneUrl);
      } catch (error) {
        _toastUtilInterface.presentErrorToast(
          text: 'No se puede abrir el número: $phoneNumber',
        );
      }
    }
  }

  static String getInitialsFromText(String? title) {
    try {
      if (title == null || title.isEmpty) {
        return 'SN';
      }

      final List<String> words = title.split(' ');
      final List<String> initials = words
          .map((word) => word[0])
          .map((initial) => initial.toUpperCase())
          .toList();

      final String result = initials.join();
      return result.length > 3 ? result.substring(0, 3) : result;
    } catch (e) {
      ToolsHelper.logger.e('[tools_helper] (getInitialsFromText)', e);
      return 'SN';
    }
  }

  /// Return user name of [email]
  /// Example:
  ///  - jjvillavicencio@utpl.edu.ec -> jjvillavicencio
  static String getUsernameOfEmail(String? email) {
    try {
      if (email == null || email.isEmpty) {
        return '';
      }

      final RegExp regex = RegExp(r'(.*)(?=@)');
      final String? result = regex.firstMatch(email)?.group(0);
      return result ?? '';
    } catch (error) {
      ToolsHelper.logger.e('[tools_helper] (getUsernameOfEmail)', error);
      return '';
    }
  }

  /// Remove underscore line of [description]
  static String wipeMsEventDescription(String? description) {
    try {
      if (description == null || description.isEmpty) {
        return '';
      }

      final RegExp regex = RegExp(r'(^_*)');
      final String? result = regex.firstMatch(description)?.group(0);
      if (result != null && result.isNotEmpty) {
        return description.replaceFirst(result, '').trimLeft();
      }
      return description;
    } catch (error) {
      ToolsHelper.logger.e('[tools_helper] (wipeMsEventDescription)', error);
      return description ?? '';
    }
  }

  /// Convert html code [text] to plain string
  static String htmlParser(String? text) {
    if (text != null && (text.isNotEmpty)) {
      var document = parse(text);
      return document.documentElement!.text;
    } else {
      return '';
    }
  }

  /// Configure the ADFS authentication parameters.
  static AadOAuth get adfsConfig {
    final Config config = Config(
      aOptions: const AndroidOptions(),
      isB2C: false,
      tenant: Environment.adfsTenant,
      clientId: Environment.adfsClientId,
      scope: Environment.adfsScope,
      redirectUri: Environment.adfsRedirectUri,
      navigatorKey: _mainCtrl.navigatorKey,
      domainHint: "utpl.edu.ec",
    );

    return AadOAuth(config);
  }

  static String formatToTimeAgo(DateTime dateTime) =>
      time_ago.format(dateTime, locale: 'es');
}
