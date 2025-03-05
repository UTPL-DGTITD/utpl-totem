import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/routes/app_pages.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';
import 'package:utpl_totem_oficial/app/utils/types/interaction_generic_item_type.dart';

class BannerController extends GetxController with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  //final AuthService authService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  final title = 'Banner UTPL'.obs;

  RxList<GenericListItemModel> bannerSlide = <GenericListItemModel>[].obs;
  final slider.CarouselSliderController buttonCarouselController =
      slider.CarouselSliderController();

  BannerController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
    //required this.authService,
  });

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  void _initConfig() async {
    try {
      await loadBanners();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[banner_controller] (_initConfig)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  Future<void> loadBanners() async {
    try {
      showSkeleton.value = true;
      var result = await apiRepository.getBannersAvailable();
      switch (result.status) {
        case 200:
          bannerSlide.assignAll(genericListItemModelFromList(result.data));
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
        '[banner_controller] (loadBanners)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  navigateToBannerDetail(GenericListItemModel banner) {
    if (banner.interaction == InteractionGenericItemType.link) {
      if (banner.link != null && banner.link!.url.isNotEmpty) {
        if (banner.link?.target == "app") {
          Get.toNamed(Routes.web, arguments: {
            "url": banner.link?.url,
            "title": banner.title,
          });
        } else {
          ToolsHelper.openUrl(url: banner.link!.url);
        }
      } else {
        toastService.presentWarningToast(
          text: "El enlace no se encuentra disponible, intenta más tarde.",
        );
      }
    } else {
      toastService.presentWarningToast(
        text: "Por el momento no se puede visualizar este elemento",
      );
    }
  }
}
