import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/presentation/modules/ranking/ranking_controller.dart';
import 'package:utpl_totem/app/themes/utpl_custom_icons.dart';

class CarrouselSliderRanking extends StatelessWidget {
  const CarrouselSliderRanking({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<RankingController>();
    final CarouselController buttonCarouselController = CarouselController();
    return CarouselSlider.builder(
      carouselController: buttonCarouselController,
      options: CarouselOptions(
        autoPlay: true,
        onPageChanged: (index, reason) => ctrl.onChangeImg(index),
        height: ctrl.responsive.hp(15),
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: ctrl.rankingDetails.isNotEmpty,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      itemCount: ctrl.rankingDetails.length,
      itemBuilder: (
        BuildContext context,
        int index,
        int pageViewIndex,
      ) =>
          _ImgRanking(
        index: index,
      ),
    );
  }
}

class _ImgRanking extends StatelessWidget {
  final int index;
  const _ImgRanking({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<RankingController>();
    return SizedBox(
      width: double.maxFinite,
      child: GestureDetector(
        // onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ctrl.responsive.wp(5)),
          child: CachedNetworkImage(
            imageUrl: ctrl.rankingDetails[index].image?.url ?? '',
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
