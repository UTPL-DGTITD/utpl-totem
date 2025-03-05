import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';

class CustomDecoration {
  static InputDecoration roundedDropdown({
    String? hintText,
  }) {
    final responsive = Responsive();

    return InputDecoration(
      hintText: hintText ?? 'Seleccione una opción',
      contentPadding: EdgeInsets.symmetric(
        horizontal: responsive.wp(4),
        vertical: responsive.hp(1),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    );
  }

  static InputDecoration authInputDecoration({
    required String labelText,
    required Function onTap,
    IconData? icon,
  }) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Get.theme.colorScheme.primary,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Get.theme.colorScheme.primary,
          width: 2,
        ),
      ),
      labelText: labelText,
      suffixIcon: InkWell(
        onTap: () => onTap(),
        child: const Icon(Icons.close),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: icon != null
          ? Icon(
              icon,
              color: Get.theme.colorScheme.primary,
            )
          : null,
    );
  }

  static InputDecoration inputRecommendationDecoration({
    required String? hintText,
    required String? text,
  }) {
    final responsive = Responsive();
    return InputDecoration(
      labelText: text,
      hintText: hintText,
      hintStyle: TextStyle(
        // color: Get.theme.colorScheme.primary,
        fontSize: responsive.ip(2),
        fontWeight: FontWeight.normal,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: responsive.wp(4),
        vertical: responsive.hp(2),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(
          responsive.ip(2),
        ),
      )),
      labelStyle: TextStyle(
        color: Get.theme.colorScheme.primary,
        fontSize: responsive.ip(2),
      ),
    );
  }
}
