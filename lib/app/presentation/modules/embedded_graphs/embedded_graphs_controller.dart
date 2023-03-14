import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class EmbeddedGraphsController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  RxString title = 'Gráficas'.obs;

  RxList<String> lsUrls = <String>[].obs;
  RxString currentUrl = ''.obs;
  RxInt currentIndex = 0.obs;

  EmbeddedGraphsController({
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
      loadGraphs();
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[embedded_graphs_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void loadGraphs() {
    lsUrls.value =
        ['https://appmovil.utpl.edu.ec/', 'https://www.utpl.edu.ec/'].obs;
    currentUrl.value = lsUrls[currentIndex.value];
  }

  void moveLeft() {
    print('IZQUIERDA');
    if (!(currentIndex.value == 0)) {
      currentIndex.value--;
      currentUrl.value = lsUrls[currentIndex.value];
    }
  }

  void moveRight() {
    print('DERECHA');
    if (currentIndex.value < lsUrls.length - 1) {
      currentIndex.value++;
      currentUrl.value = lsUrls[currentIndex.value];
    }
  }
}
