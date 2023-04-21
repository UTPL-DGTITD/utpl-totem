import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/tv_template_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class GraphController extends GetxController with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;

  final responsive = Responsive();

  RxBool showSkeleton = false.obs;
  final title = 'Gráficos UTPL'.obs;

  Rx<TvTemplateBody> currentItem = TvTemplateBody().obs;

  GraphController({
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
    try {} catch (error, stack) {
      ToolsHelper.logger.e(
        '[graph_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  List<int> getGraphValues(TvTemplateBody item) {
    List<int> values = [];
    for (var i = 0; i < item.graphData.length; i++) {
      values.add(item.graphData[i].value);
    }
    return values;
  }
}
