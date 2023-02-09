import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/utils/constants/toast_position.dart';

class ToastService extends GetxService {
  hideLoading() {
    BotToast.closeAllLoading();
  }

  void presentErrorToast({
    String title = 'Error',
    required String text,
    double position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 4),
    bool clickClose = true,
    double radius = 13,
    double fontSize = 18,
  }) {
    BotToast.showCustomNotification(
      align: Alignment(0, position),
      duration: duration,
      toastBuilder: (cancel) {
        return Card(
          color: Get.theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Get.theme.errorColor,
                    width: 9,
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 5,
                  bottom: 7,
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cancel,
                      size: 34,
                      color: Get.theme.errorColor,
                    ),
                  ],
                ),
                title: Text(
                  title,
                  style: Get.textTheme.bodyText1?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  text,
                  style: Get.textTheme.bodyText1?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Get.theme.dividerColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: cancel,
                        child: Text(
                          'CERRAR',
                          style: Get.textTheme.bodyText1?.copyWith(
                            fontSize: 16,
                            color: Get.theme.dividerColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void presentWarningToast({
    String title = 'Información',
    required String text,
    double position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 4),
    bool clickClose = true,
    double radius = 13,
    double fontSize = 18,
  }) {
    BotToast.showCustomNotification(
      align: Alignment(0, position),
      duration: duration,
      toastBuilder: (cancel) {
        return Card(
          color: Get.theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Get.theme.colorScheme.primary,
                    width: 9,
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 5,
                  bottom: 7,
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      size: 34,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ],
                ),
                title: Text(
                  title,
                  style: Get.textTheme.bodyText1?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  text,
                  style: Get.textTheme.bodyText1?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Get.theme.dividerColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: cancel,
                        child: Text(
                          'CERRAR',
                          style: Get.textTheme.bodyText1?.copyWith(
                            fontSize: 16,
                            color: Get.theme.dividerColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  presentLoading() {
    BotToast.showLoading();
  }

  presentNotification({
    required String text,
    bool closeButton = true,
    duration = const Duration(milliseconds: 5000),
  }) {
    BotToast.showSimpleNotification(
      title: text,
      hideCloseButton: !closeButton,
      duration: duration,
    );
  }

  void presentToast({
    String title = 'Correcto',
    required String text,
    Color color = Colors.green,
    double position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 4),
    bool clickClose = true,
    double radius = 13,
    double fontSize = 18,
  }) {
    BotToast.showCustomNotification(
      align: Alignment(0, position),
      duration: duration,
      toastBuilder: (cancel) {
        return Card(
          color: Get.theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: color,
                    width: 9,
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 5,
                  bottom: 7,
                ),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 34,
                      color: color,
                    ),
                  ],
                ),
                title: Text(
                  title,
                  style: Get.textTheme.bodyText1?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  text,
                  style: Get.textTheme.bodyText1?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  height: double.maxFinite,
                  padding: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Get.theme.dividerColor.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: cancel,
                        child: Text(
                          'CERRAR',
                          style: Get.textTheme.bodyText1?.copyWith(
                            fontSize: 16,
                            color: Get.theme.dividerColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
