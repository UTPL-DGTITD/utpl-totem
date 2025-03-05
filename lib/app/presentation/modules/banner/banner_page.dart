import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;

import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/banner/banner_controller.dart';

class BannerPage extends GetView<BannerController> {
  const BannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() => Text(controller.title.value)),
      // ),
      body: GetX<BannerController>(
        init: BannerController(
          localRepository: Get.find(),
          apiRepository: Get.find(),
          toastService: Get.find(),
          //authService: Get.find(),
        ),
        initState: (_) {},
        builder: (ctrl) {
          return SafeArea(
              child: Center(
            child: slider.CarouselSlider.builder(
              carouselController: ctrl.buttonCarouselController,
              options: slider.CarouselOptions(
                height: ctrl.responsive.hp(22),
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: ctrl.bannerSlide.isNotEmpty,
                enlargeCenterPage: true,
                autoPlay: true,
                scrollDirection: Axis.horizontal,
              ),
              itemCount: ctrl.bannerSlide.length,
              itemBuilder: (
                BuildContext context,
                int index,
                int pageViewIndex,
              ) =>
                  Padding(
                padding: EdgeInsets.symmetric(vertical: ctrl.responsive.hp(0)),
                child: _ImgBanner(
                  item: ctrl.bannerSlide[index],
                  onSectionSelect: (item) => null,
                  // ctrl.navigateToBannerDetail(item),
                  ctrl: ctrl,
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}

class _ImgBanner extends StatelessWidget {
  final GenericListItemModel item;
  final Function(GenericListItemModel) onSectionSelect;
  final BannerController ctrl;
  const _ImgBanner({
    super.key,
    required this.item,
    required this.onSectionSelect,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.cardColor,
      padding: EdgeInsets.symmetric(
        vertical: ctrl.responsive.hp(1),
        horizontal: ctrl.responsive.wp(1),
      ),
      width: double.maxFinite,
      child: GestureDetector(
        // onTap: () => ctrl.navigateToBannerDetail(item),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ctrl.responsive.wp(0)),
          child: CachedNetworkImage(
            httpHeaders: const {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64)',
            },
            imageUrl: item.image?.url ?? '',
            fit: BoxFit.cover,
            errorWidget: (context, a, b) {
              return Image.asset('assets/images/alt-banner.png');
            },
            placeholder: (context, url) =>
                Image.asset('assets/images/alt-banner.png'),
          ),
        ),
      ),
    );
  }
}
