import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

class EmptyResultsWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String description;
  final String assetPath;
  final String btnText;
  final bool showBtn;

  const EmptyResultsWidget({
    Key? key,
    this.onTap,
    required this.description,
    required this.assetPath,
    this.btnText = 'Undefined',
    this.showBtn = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();

    return SizedBox(
      width: responsive.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          customYMargin(responsive.hp(4)),
          Image(
            image: AssetImage(assetPath),
            width: responsive.wp(70),
          ),
          customYMargin(responsive.hp(2)),
          Icon(
            Icons.info_outline,
            size: responsive.ip(4),
          ),
          customYMargin(responsive.hp(1)),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Get.textTheme.displayMedium?.copyWith(
                fontSize: responsive.ip(1.6),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          customYMargin(responsive.hp(4)),
          Visibility(
            visible: showBtn,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: responsive.wp(4),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.secondary,
                  foregroundColor: Get.theme.colorScheme.onSecondary,
                  elevation: 0,
                ),
                onPressed: onTap,
                child: Row(
                  children: [
                    Text(btnText),
                    const Spacer(),
                    const Icon(UtplCustom.right_small_arrow),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
