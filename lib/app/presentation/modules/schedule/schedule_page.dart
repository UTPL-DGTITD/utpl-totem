import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:utpl_totem/app/presentation/modules/schedule/schedule_controller.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/widgets/input_form.dart';

import 'package:utpl_totem/app/presentation/modules/schedule/widgets/schedule_results.dart';
import 'package:utpl_totem/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem/app/presentation/widgets/footer_utpl.dart';

import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: controller.responsive.hp(8),
        title: Obx(
          () => Text(
            controller.title.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: controller.responsive.ip(2.5)),
          ),
        ),
        leading: const SizedBox(),
      ),
      body: GetX<ScheduleController>(
        init: ScheduleController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
            child: ctrl.showSkeleton.isFalse
                ? Obx(
                    () => Form(
                      key: ctrl.formKey,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            //color: Colors.red,
                            height: ctrl.responsive.hp(85),
                            child: ctrl.showSchedule.isFalse
                                ? InputForm(
                                    ctrl: ctrl,
                                  )
                                : ScheduleResults(
                                    ctrl: ctrl,
                                  ),
                          ),
                          const FooterUTPL(),
                        ],
                      ),
                    ),
                  )
                : const SkeletonList(length: 20),
          );
        },
      ),
    );
  }
}
