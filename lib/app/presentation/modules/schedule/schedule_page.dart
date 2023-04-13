import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:utpl_totem/app/presentation/modules/schedule/schedule_controller.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/widgets/byUser/search_user_schedule.dart';

import 'package:utpl_totem/app/presentation/widgets/float_back_button.dart';
import 'package:utpl_totem/app/presentation/widgets/footer_utpl.dart';

import 'package:utpl_totem/app/presentation/widgets/skeleton_list.dart';

import 'widgets/byClassroom/classroom_schedule.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatBackButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        bottom: TabBar(
          controller: controller.tabController,
          tabs: controller.tabs,
          labelStyle: TextStyle(fontSize: controller.responsive.ip(2)),
        ),
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
                ? Column(
                    children: [
                      Container(
                        width: double.infinity,
                        //color: Colors.red,
                        height: ctrl.responsive.hp(77.7),
                        child: TabBarView(
                          controller: ctrl.tabController,
                          children: [
                            SearchUserSchedule(
                              ctrl: ctrl,
                            ),
                            ClassroomSchedule(
                              ctrl: ctrl,
                            ),
                          ],
                        ),
                      ),
                      const FooterUTPL(),
                    ],
                  )
                : const SkeletonList(length: 20),
          );
        },
      ),
    );
  }
}
