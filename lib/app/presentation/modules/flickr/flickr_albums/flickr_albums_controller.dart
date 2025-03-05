import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem_oficial/app/data/models/flicker_album.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/routes/app_pages.dart';
import 'package:utpl_totem_oficial/app/themes/responsive.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

class FlickrAlbumsController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  final title = 'Galería de fotos UTPL'.obs;

  RxList<FlickerAlbum> albums = <FlickerAlbum>[].obs;
  RxBool loadingAlbum = false.obs;
  final pageAlbum = 1.obs;
  final ScrollController scrollController = ScrollController();

  FlickrAlbumsController({
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
      ToolsHelper.logger.v('INICIO FLICKER');
      await loadAlbums();
      addListenerNews();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[flickr_controller] (_initConfig)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  Future<void> loadAlbums() async {
    try {
      showSkeleton.value = true;
      var result = await apiRepository.getAlbumsFlicker();
      switch (result.status) {
        case 200:
          albums.assignAll(flickerAlbumModelFromList(result.data));
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
        '[flicker_controller] (loadAlbums)',
        error: error,
        stackTrace: stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void loadMoreAlbums() async {
    loadingAlbum.value = true;

    pageAlbum.value++;
    try {
      var result = await apiRepository.getAlbumsFlicker(page: pageAlbum.value);
      switch (result.status) {
        case 200:
          albums.addAll(flickerAlbumModelFromList(result.data));
          break;
        default:
          ToolsHelper.logger.i("Not results found");
      }
      loadingAlbum.value = false;
    } on TimeoutException {
      loadingAlbum.value = false;
      toastService.presentWarningToast(
        text: "Tiempo de espera agotado",
      );
    } on SocketException {
      loadingAlbum.value = false;
      toastService.presentWarningToast(
        text: "Error de conexión",
      );
    } catch (error, stack) {
      loadingAlbum.value = false;
      ToolsHelper.logger.e(
        '[flicker_controller] (loadMoreAlbums)',
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
        loadMoreAlbums();
      }
    });
  }

  void navigateToDetail(FlickerAlbum item) async {
    await Get.toNamed(
      Routes.flickr_detail,
      arguments: {"album": item},
    );
  }
}
