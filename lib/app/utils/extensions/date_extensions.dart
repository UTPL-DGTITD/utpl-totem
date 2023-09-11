library date_time_extensions;

import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

extension DateExtension on DateTime {
  String convertToTime() {
    ToolsHelper.logger.i('DateExtension.convertToTime', this);

    var localDate = toLocal();
    var hour = localDate.hour;
    var minute = localDate.minute;

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  String toDDMMYYYY() {
    String day = this.day.toString().padLeft(2, '0');
    String month = this.month.toString().padLeft(2, '0');
    String year = this.year.toString();
    return '$day$month$year';
  }
}
