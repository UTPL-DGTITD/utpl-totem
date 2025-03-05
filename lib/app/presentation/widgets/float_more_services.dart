import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/widgets/modal_services.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';

class FloatMoreServices extends StatelessWidget {
  const FloatMoreServices({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var responsive = Responsive();
    return Stack(
      children: [
        Positioned(
          bottom: responsive.hp(4.5),
          child: SizedBox(
            // color: Colors.yellow,
            width: responsive.wp(100),
            height: responsive.hp(8),
            child: Center(
              child: FloatingActionButton(
                splashColor: Get.theme.colorScheme.tertiary,
                backgroundColor: Get.theme.colorScheme.secondaryContainer,
                onPressed: () => ModalServices.alertMoreServices(context),
                child: SizedBox(
                  child: Icon(
                    UtplCustom.services_apps,
                    color: Get.theme.colorScheme.onSecondary,
                    size: responsive.ip(2.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
