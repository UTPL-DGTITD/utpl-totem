import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/routes/app_pages.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class RankingController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;

  final rankingDetails = <GenericListItemModel>[].obs;
  final selectedRanking = GenericListItemModel().obs;
  final CarouselController buttonCarouselController = CarouselController();

  final hasRanking = false.obs;
  final selectedIndex = 0.obs;

  RxString title = 'Ranking UTPL'.obs;

  RankingController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
    required this.authService,
  });

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  void _initConfig() async {
    try {
      loadRankings();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[ranking_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void loadRankings() async {
    try {
      showSkeleton.value = true;

      var result = await apiRepository.getRanking();
      switch (result.status) {
        case 200:
          rankingDetails.assignAll(genericListItemModelFromList(result.data));
          if (rankingDetails.isNotEmpty) {
            hasRanking.value = true;
            selectedIndex.value = 0;
            selectedRanking.value = rankingDetails[selectedIndex.value];
          }
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      showSkeleton.value = false;
    } on TimeoutException {
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[ranking_controller] (loadRankings)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Ocurrió un error, intenta nuevamente.',
      );
    }
  }

  void onChangeImg(int index) {
    selectedIndex.value = index;
    selectedRanking.value = rankingDetails[selectedIndex.value];
  }

  void navigateToUrl(String url, String title) {
    Get.toNamed(Routes.web, arguments: {
      "url": url,
      "title": title,
    });
  }
}
