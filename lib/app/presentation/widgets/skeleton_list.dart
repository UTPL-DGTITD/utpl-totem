import 'package:flutter/material.dart';

import 'package:g_skeleton/g_skeleton.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/themes/app_theme.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';

class SkeletonList extends StatefulWidget {
  const SkeletonList({
    super.key,
    required int length,
  }) : _length = length;

  final int _length;

  @override
  SkeletonListState createState() => SkeletonListState();
}

class SkeletonListState extends State<SkeletonList> {
  SkeletonController skeletonController = SkeletonController(
    begin: Get.isDarkMode
        ? DarkSchema.darkColorLight
        : LightSchema.secondaryColorLight,
    end: Get.isDarkMode
        ? DarkSchema.darkColorDark
        : LightSchema.secondaryColorDark,
  );
  Responsive responsive = Responsive();
  UniqueKey increasing = UniqueKey();

  @override
  void initState() {
    super.initState();
    skeletonController.start();

    Future.delayed(const Duration(seconds: 20))
        .then((value) => skeletonController.stop());
  }

  @override
  void dispose() {
    super.dispose();
    skeletonController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: _buildItems(widget._length),
      ),
    );
  }

  List<Widget> _buildItems(int length) {
    final items = <Widget>[];

    List.generate(
      length,
      (index) => items.add(
        SizedBox(
          width: responsive.width,
          height: 100,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Skeleton(skeletonController),
                          )),
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: FractionallySizedBox(
                            widthFactor: 0.7,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Skeleton(skeletonController),
                            )),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 2,
                        child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Skeleton(skeletonController),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return items;
  }
}
