import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/academic_calendar/academic_calendar_controller.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';

class ModalityItem extends StatelessWidget {
  final int index;

  const ModalityItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AcademicCalendarController>();
    var responsive = Responsive();
    var item = ctrl.modalitiesDetails[index];
    return FadeInLeft(
      duration: const Duration(milliseconds: 100),
      child: Obx(
        () => ChoiceChip(
          selectedColor:
              Get.theme.colorScheme.tertiaryContainer.withOpacity(0.9),
          backgroundColor:
              Get.theme.colorScheme.tertiaryContainer.withOpacity(0.4),
          label: Text(
            item.title,
            style: Get.textTheme.titleLarge?.copyWith(
              fontSize: responsive.ip(1.5),
              fontWeight: FontWeight.normal,
              color: ctrl.selectedIndexModality.value == index
                  ? Colors.black
                  : Colors.black,
            ),
          ),
          selected: ctrl.selectedIndexModality.value == index,
          onSelected: (bool selected) {
            ctrl.onChangeModality(item.title, index, item.id);
          },
        ),
      ),
    );
  }
}
