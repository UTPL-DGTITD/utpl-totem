// ignore_for_file: constant_identifier_names

part of './app_pages.dart';

abstract class Routes {
  /// Page to display when app not have internet connection
  static const network_error = '/network_error_page';

  /// Page for splash screen
  static const splash_screen = '/splash_screen_page';
  static const web = '/web_page';
  static const home = '/home_page';

  /// Page for news page
  static const news = '/news_page';

  /// Page for events page
  static const events = '/events_page';

  /// Page for validate mac of device
  static const validate = '/validate_page';

  /// Page for template offline
  static const template_offline = '/template_offline_page';

  /// Page for template static
  static const template_static = '/template_static_page';

  /// Page for template observatory detail
  static const observatory_detail = '/observatory_detail_page';

  /// Page for screen protector
  static const screen_protector = '/screen_protector_page';

  /// Page for schedule
  static const schedule = '/schedule_page';
}
