import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/validate/validate_controller.dart';
import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';
import 'package:utpl_totem/app/themes/app_theme.dart';
import 'package:utpl_totem/app/themes/custom_decoration.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class ValidatePage extends GetView<ValidateController> {
  const ValidatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<ValidateController>(
        init: ValidateController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
              child: ctrl.showSkeleton.isFalse
                  ? Center(
                      child: Form(
                      key: ctrl.formKey,
                      child: Container(
                        color: Get.theme.cardColor,
                        height: ctrl.responsive.hp(60),
                        width: ctrl.responsive.wp(100),
                        padding: EdgeInsets.symmetric(
                          horizontal: ctrl.responsive.wp(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'UTPL+',
                              style: Get.textTheme.headline6?.copyWith(
                                fontSize: ctrl.responsive.ip(4),
                                fontWeight: FontWeight.bold,
                                color: LightSchema.primaryColor,
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(2)),
                            Text(
                              'Ingrese el código del dispositivo',
                              style: Get.textTheme.headline6?.copyWith(
                                fontSize: ctrl.responsive.ip(2),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(2)),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: ctrl.responsive.wp(0),
                              ),
                              child: TextFormField(
                                controller: ctrl.descriptionController.value,
                                // maxLength: 10,

                                autocorrect: false,
                                decoration: CustomDecoration
                                    .inputRecommendationDecoration(
                                  hintText: ctrl.deviceCode.value,
                                  text: 'Código',
                                ),
                                maxLines: 1,
                                keyboardType: TextInputType.multiline,
                                validator: (value) =>
                                    ctrl.validatorsForm.validateLength(
                                  value: value,
                                  min: 5,
                                  max: 50,
                                ),
                                onChanged: (value) => ctrl.onChangeCode(value),
                              ),
                            ),
                            customYMargin(ctrl.responsive.hp(2)),
                            Container(
                              decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: ctrl.responsive.wp(6),
                                vertical: ctrl.responsive.hp(2),
                              ),
                              width: double.maxFinite,
                              margin: EdgeInsets.symmetric(
                                horizontal: ctrl.responsive.wp(2),
                              ),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                color: Get.theme.colorScheme.tertiary,
                                child: Text(
                                  'Enviar',
                                  style: Get.textTheme.headline5?.copyWith(
                                    fontSize: ctrl.responsive.ip(1.5),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  ToolsHelper.hideKeyboard(context);
                                  ctrl.validateCode();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                  : const SkeletonList(length: 20));
        },
      ),
    );
  }
}
