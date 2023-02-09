import 'package:card_swiper/card_swiper.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/presentation/modules/flickr/flick_controller.dart';
import 'package:utpl_totem/app/themes/custom_margin.dart';

class FlickrPage extends GetView<FlickrController> {
  final TvTemplateBody item;
  const FlickrPage(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      FlickrController(
        localRepository: Get.find(),
        apiRepository: Get.find(),
        toastService: Get.find(),
        authService: Get.find(),
      ),
    );
    ctrl.currentItem.value = item;
    ctrl.currentFlickrDesc.value = item.flickrData.first.title;
    // ctrl.load(item.embeddedYoutube);
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<FlickrController>(
        init: FlickrController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return Center(
            child: Container(
              color: Get.theme.canvasColor,
              padding: EdgeInsets.symmetric(
                horizontal: ctrl.responsive.wp(1),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            child: Text(
                              'Flickr UTPL',
                              style: TextStyle(
                                fontSize: ctrl.responsive.ip(1.5),
                                color: Get.theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        customYMargin(ctrl.responsive.hp(1)),
                        Center(
                          child: Container(
                            child: Text(
                              ctrl.currentFlickrDesc.value,
                              style: TextStyle(
                                fontSize: ctrl.responsive.ip(1.25),
                                color: Get.theme.colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        //color: Colors.red,
                        child: Swiper(
                          autoplay: false,
                          onIndexChanged: (index) => ctrl.onChangueFlckr(
                              ctrl.currentItem.value, index),
                          itemCount: ctrl.currentItem.value.flickrData.length,
                          layout: SwiperLayout.STACK,
                          itemWidth: ctrl.responsive.wp(20),
                          itemHeight: ctrl.responsive.hp(30),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () => null,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/images/alt-image.png'),
                                  image: NetworkImage(ctrl.currentItem.value
                                      .flickrData[index].urlM),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
