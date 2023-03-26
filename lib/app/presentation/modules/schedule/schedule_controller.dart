import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/extra_base_model.dart';
import 'package:utpl_totem/app/data/models/generic_list_item_model.dart';
import 'package:utpl_totem/app/data/models/generic_schedule_model.dart';
import 'package:utpl_totem/app/data/models/related_base_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/data/services/toast_service.dart';
import 'package:utpl_totem/app/presentation/modules/schedule/widgets/modal_dialog_ranking.dart';
import 'package:utpl_totem/app/themes/responsive.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';
import 'package:utpl_totem/app/utils/validators/validators_forms.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class ScheduleController extends GetxController
    with GetTickerProviderStateMixin {
  final LocalRepository localRepository;
  final ApiRepository apiRepository;
  final ToastService toastService;
  final AuthService authService;

  final responsive = Responsive();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValidatorsForm validatorsForm = ValidatorsForm();
  Rx<TextEditingController> inputController =
      TextEditingController(text: '').obs;
  final username = ''.obs;
  RxList<GenericScheduleModel> userSchedule = <GenericScheduleModel>[].obs;
  RegExp regExp =
      RegExp(r'^[a-zA-Z0-9\b\u{0008}]+$'); //RegExp(r'[a-zA-Z0-9\b]');

  RxBool showSkeleton = false.obs;
  RxBool showSchedule = false.obs;
  final title = 'Horarios'.obs;
  ScrollController contentScrollController = ScrollController();
  ScrollController contentResultsScrollController = ScrollController();

  ScheduleController({
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

  @override
  void onClose() {
    super.onClose();
  }

  void _initConfig() async {
    try {} catch (error, stack) {
      ToolsHelper.logger.e(
        '[schedule_controller] (_initConfig)',
        error,
        stack,
      );
      toastService.presentErrorToast(
        text: "La información necesaria es incorrecta",
      );
      Get.back();
    }
  }

  void onChangeUsername(String value) async {
    ToolsHelper.logger.v(value);
    username.value = value;
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void validateUsername(BuildContext context, ScheduleController ctrl) async {
    if (isValidForm()) {
      ToolsHelper.logger.v('VALIDO');
      try {
        toastService.presentLoading();
        var result = await apiRepository.getSubjectSchedule(
          body: {
            "user": inputController.value.text,
          },
        );
        switch (result.status) {
          case 200:
            toastService.hideLoading();
            userSchedule.assignAll(genericScheduleModelFromList(result.data));
            ToolsHelper.logger.v(userSchedule.toJson());
            showSchedule.value = true;
            //ModalDialogSchedule.alertSchedule(context, userSchedule, ctrl);

            break;
          case 404:
            toastService.presentWarningToast(
              text: "No existe información para el usuario ingresado",
            );
            toastService.hideLoading();
            break;

          default:
        }
      } on TimeoutException {
        toastService.hideLoading();
        toastService.presentWarningToast(
          text: "Tiempo de espera agotado",
        );
      } on SocketException {
        toastService.hideLoading();

        toastService.presentWarningToast(
          text: "Error de conexión",
        );
      } catch (error, stack) {
        toastService.hideLoading();

        ToolsHelper.logger.e(
          '[schedule_controller] (validateUsername)',
          error,
          stack,
        );
        toastService.presentErrorToast(
          text: 'Error nuestro, intenta más tarde',
        );
      }
    }
  }

  void clearInput() {
    inputController.value.text = '';
  }

  onKeyPressed(VirtualKeyboardKey key) {
    //ToolsHelper.logger.v(key.keyType);
    ToolsHelper.logger.v(key.action);
    if (regExp.hasMatch(key.text ?? '')) {
      // Solo se permite insertar números y letras
      inputController.value.text += key.text ?? '';
    }
    if (key.action == VirtualKeyboardKeyAction.Backspace) {
      if (inputController.value.text != '') {
        inputController.value.text = inputController.value.text
            .substring(0, inputController.value.text.length - 1);
      }
    }
  }

  void newQuery() {
    showSchedule.value = false;
    clearInput();
  }

  void showModal(GenericScheduleModel item, BuildContext context,
      ScheduleController ctrl, Datum datum) {
    ModalDialogSchedule.alertSchedule(context, item, ctrl, datum);
  }

  String? getStringByIdentifier(
      List<RelatedBaseModel>? relation, String identifier) {
    if (relation == null || relation.isEmpty) {
      return null;
    }

    var link =
        relation.firstWhereOrNull((element) => element.type == identifier);
    return (link?.name != null && link!.name.isNotEmpty) ? link.name : null;
  }
}
