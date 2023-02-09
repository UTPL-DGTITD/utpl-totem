import 'package:flutter/material.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/themes/app_theme.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';
import 'package:utpl_totem/app/utils/types/interaction_generic_item_type.dart';

class TrailingCardGeneric extends StatelessWidget {
  final GenericListItemModel item;

  const TrailingCardGeneric({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (item.interaction) {
      case InteractionGenericItemType.link:
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: AuxSchema.successColorLight.withOpacity(0.2),
          ),
          child: const Text(
            "Abrir",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AuxSchema.successColorDark,
            ),
          ),
        );
      case InteractionGenericItemType.app:
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: AuxSchema.successColorLight.withOpacity(0.2),
          ),
          child: const Text(
            "Ejecutar",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AuxSchema.successColorDark,
            ),
          ),
        );
      default:
        return const Icon(UtplCustom.right_small_arrow);
    }
  }
}
