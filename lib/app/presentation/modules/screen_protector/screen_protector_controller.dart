import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class ScreenProtectorController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  RxString title = 'Protector de Pantalla'.obs;
  Rx<GenericListItemModel> wallpaper = GenericListItemModel().obs;
  Color colorContent = const Color(0xFFCACACA);

  ScreenProtectorController({
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
    } catch (error, stack) {
      ToolsHelper.logger.e(
        '[screen_protector_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void exitScreenProtector() {
    Get.back();
  }

  void _loadRouteParams() {
    final params = Get.arguments;
    assert(params != null, 'Params is required');
    assert(params['wallpaper'] != null, 'wallpaper is required');
    assert(params['wallpaper'] is GenericListItemModel,
        'wallpaper is not type GenericListItemModel');
    wallpaper.value = params['wallpaper'];
  }
}
