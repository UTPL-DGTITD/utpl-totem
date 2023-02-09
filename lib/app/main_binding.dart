import 'package:get/instance_manager.dart';
import 'package:utpl_totem/app/controllers/main_controller.dart';
import 'package:utpl_totem/app/data/providers/api_provider.dart';
import 'package:utpl_totem/app/data/providers/local_provider.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LocalRepository>(
      LocalProvider(),
    );
    Get.put<MainController>(
      MainController(),
    );
    Get.put<ApiRepository>(
      ApiProvider(),
    );
    Get.put(
      ToastService(),
    );
    Get.put(
      AuthService(),
    );
  }
}
