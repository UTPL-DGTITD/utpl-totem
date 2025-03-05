import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

class NewsController extends GetxController with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  final title = 'Noticias UTPL'.obs;

  RxList<GenericListItemModel> news = <GenericListItemModel>[].obs;
  RxBool loadingNews = false.obs;
  final pageNews = 1.obs;
  final ScrollController scrollController = ScrollController();

  NewsController({
    required this.localRepository,
    required this.apiRepository,
    required this.toastService,
  });

  @override
  void onInit() {
    _initConfig();
    super.onInit();
  }

  void _initConfig() async {
    try {
      await loadNews();
      addListenerNews();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[events_controller] (_initConfig)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  Future<void> loadNews() async {
    try {
      showSkeleton.value = true;
      var result = await apiRepository.getNewsPreview();
      switch (result.status) {
        case 200:
          news.assignAll(genericListItemModelFromList(result.data));
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
        '[news_controller] (loadNews)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void loadMoreNews() async {
    loadingNews.value = true;

    pageNews.value++;
    try {
      var result = await apiRepository.getNewsPreview(page: pageNews.value);
      switch (result.status) {
        case 200:
          news.addAll(genericListItemModelFromList(result.data));
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      loadingNews.value = false;
    } on TimeoutException {
      loadingNews.value = false;
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      loadingNews.value = false;
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      loadingNews.value = false;
      ToolsHelper.logger.e(
        '[home_controller] (loadMoreNews)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void addListenerNews() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          (scrollController.position.maxScrollExtent)) {
        loadMoreNews();
      }
    });
  }
}
