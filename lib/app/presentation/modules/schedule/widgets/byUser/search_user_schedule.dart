import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/schedule/schedule_controller.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/schedule/widgets/byUser/schedule_results.dart';
import 'package:utpl_totem_oficial/app/themes/custom_decoration.dart';
import 'package:utpl_totem_oficial/app/themes/custom_margin.dart';
import 'package:utpl_totem_oficial/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class SearchUserSchedule extends StatelessWidget {
  final ScheduleController ctrl;
  const SearchUserSchedule({
    super.key,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ctrl.showSchedule.isFalse
          ? Form(
              key: ctrl.formKey,
              child: Container(
                width: double.infinity,
                color: Get.theme.cardColor,
                padding: EdgeInsets.symmetric(
                  vertical: ctrl.responsive.hp(2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ingrese su usuario UTPL',
                      style: TextStyle(
                        fontSize: ctrl.responsive.ip(2),
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    customYMargin(ctrl.responsive.hp(2)),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ctrl.responsive.wp(5)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: ctrl.responsive.wp(0),
                              ),
                              child: TextFormField(
                                enabled: false,
                                style: TextStyle(
                                  // color: Get.theme.colorScheme.primary,
                                  fontSize: ctrl.responsive.ip(2),
                                  fontWeight: FontWeight.normal,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(ctrl.regExp)
                                ],
                                controller: ctrl.inputController.value,
                                // maxLength: 10,
                                autocorrect: false,
                                decoration: CustomDecoration
                                    .inputRecommendationDecoration(
                                  hintText: 'Ingrese su usuario UTPL',
                                  text: 'Usuario',
                                ),
                                maxLines: 1,
                                keyboardType: TextInputType.multiline,
                                validator: (value) =>
                                    ctrl.validatorsForm.validateLength(
                                  value: value,
                                  min: 1,
                                  max: 30,
                                ),
                                onChanged: (value) =>
                                    ctrl.onChangeUsername(value),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => ctrl.clearInput(),
                              child: Icon(
                                Icons.clear,
                                size: ctrl.responsive.ip(3),
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    customYMargin(ctrl.responsive.hp(2)),
                    Container(
                      color: Get.theme.colorScheme.primary,
                      child: VirtualKeyboard(
                        height: ctrl.responsive.hp(35),
                        textColor: Colors.white,
                        fontSize: ctrl.responsive.ip(1.8),
                        //textController: ctrl.inputController.value,
                        defaultLayouts: const [
                          VirtualKeyboardDefaultLayouts.English
                        ],
                        type: VirtualKeyboardType.Alphanumeric,
                        onKeyPress: (key) => ctrl.onKeyPressed(key),
                      ),
                    ),
                    customYMargin(ctrl.responsive.hp(2)),
                    Container(
                      decoration: BoxDecoration(
                        color: Get.theme.cardColor,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ctrl.responsive.wp(10),
                        vertical: ctrl.responsive.hp(1),
                      ),
                      width: double.maxFinite,
                      child: MaterialButton(
                        padding: EdgeInsets.symmetric(
                          vertical: ctrl.responsive.hp(3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        color: Get.theme.colorScheme.tertiary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Consultar ',
                              style: Get.textTheme.headlineMedium?.copyWith(
                                fontSize: ctrl.responsive.ip(2),
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              UtplCustom.right_small_arrow,
                              color: Get.theme.colorScheme.primary,
                              size: ctrl.responsive.ip(3.5),

                              //size: controller.responsive.ip(2),
                            ),
                          ],
                        ),
                        onPressed: () {
                          ToolsHelper.hideKeyboard(context);
                          ctrl.validateUsername(context, ctrl);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ScheduleResults(
              ctrl: ctrl,
            ),
    );
  }
}
