import 'package:get/instance_manager.dart';
import 'package:utpl_totem_oficial/app/controllers/main_controller.dart';
import 'package:utpl_totem_oficial/app/data/providers/api_provider.dart';
import 'package:utpl_totem_oficial/app/data/providers/local_provider.dart';
import 'package:utpl_totem_oficial/app/data/repositories/api_repository.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/data/services/toast_service.dart';
import 'package:utpl_totem_oficial/app/presentation/modules/videos_module/videos_module_controller.dart';

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
    // Agregar el controlador de videos aquí
    Get.put<VideosModuleController>(
      VideosModuleController(),
    );
  }
}
