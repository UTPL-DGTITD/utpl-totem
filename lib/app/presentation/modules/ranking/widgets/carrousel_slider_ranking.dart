import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;

import 'package:utpl_totem_oficial/app/presentation/modules/ranking/ranking_controller.dart';

class CarrouselSliderRanking extends StatelessWidget {
  final RankingController ctrl;
  const CarrouselSliderRanking({
    super.key,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final slider.CarouselSliderController buttonCarouselController =
        slider.CarouselSliderController();
    return slider.CarouselSlider.builder(
      carouselController: buttonCarouselController,
      options: slider.CarouselOptions(
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
        ctrl: ctrl,
      ),
    );
  }
}

class _ImgRanking extends StatelessWidget {
  final RankingController ctrl;
  final int index;
  const _ImgRanking({
    super.key,
    required this.index,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: GestureDetector(
        // onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ctrl.responsive.wp(5)),
          child: CachedNetworkImage(
            httpHeaders: const {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64)',
            },
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
