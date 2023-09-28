import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/flicker_album.dart';
import 'package:utpl_totem/app/data/models/flicker_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/presentation/widgets/modal_image.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class FlickrAlbumDetailController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  final title = 'Detalle Album'.obs;
  Rx<FlickerAlbum> album = FlickerAlbum().obs;

  final actualUrlImg = ''.obs;
  final actualIndexImg = 0.obs;

  RxList<FlickrModel> albumFlicker = <FlickrModel>[].obs;

  FlickrAlbumDetailController({
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
      _loadRouteParams();
      loadAlbum();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[flickr_detail_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void _loadRouteParams() {
    final params = Get.arguments;
    assert(params != null, 'Params is required');
    assert(params['album'] != null, 'album is required');
    assert(params['album'] is FlickerAlbum, 'album is not type String');
    album.value = params['album'];
    title.value = album.value.title?.content ?? 'Detalle';
  }

  Future<void> loadAlbum() async {
    try {
      showSkeleton.value = true;
      var result =
          await apiRepository.getFlickerByAlbum(idAlbum: album.value.id);
      switch (result.status) {
        case 200:
          ToolsHelper.logger.v('HAY ALBUM');
          albumFlicker.assignAll(flickrModelFromList(result.data));

          break;
        case 404:
          ToolsHelper.logger.i("Not results found - NO ALBUM");
          break;
        default:
          ToolsHelper.logger.i("Not results found - NO ALBUM");
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
        '[flickr_controller] (loadAlbum)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: 'Error nuestro, intenta más tarde',
      );
    }
  }

  void showModalImg(
      BuildContext context, index, FlickrAlbumDetailController ctrl) {
    actualUrlImg.value = ctrl.albumFlicker[index].urlM;
    actualIndexImg.value = index;
    ModalImage.showImage(
      context,
      actualUrlImg.value,
      ctrl,
    );
  }

  void nextImg(int index) {
    ToolsHelper.logger.v('NEXT: $index');
    if (index < albumFlicker.length - 1) {
      actualUrlImg.value = albumFlicker[index + 1].urlM;
      actualIndexImg.value = index + 1;
      update();
    }
  }

  void previusImg(int index) {
    ToolsHelper.logger.v('PREVIUS: $index');
    if (index > 0) {
      actualUrlImg.value = albumFlicker[index - 1].urlM;
      actualIndexImg.value = index - 1;
      update();
    }
  }
}
