// ignore_for_file: constant_identifier_names

part of './app_pages.dart';

abstract class Routes {
  /// Page to display when app not have internet connection
  static const network_error = '/network_error_page';

  /// Page for splash screen
  static const splash_screen = '/splash_screen_page';
  static const web = '/web_page';
  static const home = '/home_page';

  /// Page for validate mac of device
  static const validate = '/validate_page';

  /// Page for template offline
  static const template_offline = '/template_offline_page';

  /// Page for template static
  static const template_static = '/template_static_page';
}
