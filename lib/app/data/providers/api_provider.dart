import 'package:utpl_totem/app/data/models/api_response_model.dart';
import 'package:utpl_totem/app/data/models/observatory_detail_model.dart';
import 'package:utpl_totem/app/data/repositories/api_repository.dart';
import 'package:utpl_totem/app/utils/helpers/network_helper.dart';

class ApiProvider extends ApiRepository {
  final NetworkUtil _netUtil = NetworkUtil();

  /* -------------------------------------------------------------------------- */
  /*                                   STATUS                                   */
  /* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getBackendStatus() {
    return _netUtil.get(path: 'status').then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                  SERVICES                                  */
  /* -------------------------------------------------------------------------- */
  @override
  Future<ApiResponseModel> getServicesPaginated({int page = 1}) {
    return _netUtil.get(path: 'v2/service/tv?page=1').then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

  @override
  Future<ApiResponseModel> addCountService({required String idService}) {
    return _netUtil
        .get(path: '/v1/service/count/$idService')
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                   BANNER                                   */
  /* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getBannersAvailable() {
    return _netUtil.get(path: 'v1/banner/home/top').then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

/* -------------------------------------------------------------------------- */
/*                              ACADEMIC CALENDAR MODALITIES                  */
/* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getAcademicCalendarModalities() {
    return _netUtil
        .get(
      path: 'v1/academic/modality/all',
    )
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

/* -------------------------------------------------------------------------- */
/*                              ACADEMIC CALENDAR ACTIVITIES BY MODALITY      */
/* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getActivitiesByModality({
    required String idModality,
  }) {
    return _netUtil
        .get(
      path: 'v1/academic/activity/modality/$idModality/all',
    )
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                  TV Templates                              */
  /* -------------------------------------------------------------------------- */
  @override
  Future<ApiResponseModel> getTvTemplates() {
    return _netUtil.get(path: 'v2/tv/header/all').then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

/* -------------------------------------------------------------------------- */
/*                              TV TEMPLATE BY CODE                           */
/* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getTvTemplateByCode({
    required Map<String, dynamic> body,
  }) {
    return _netUtil
        .post(
      path: 'v3/tv/information/validate',
      body: body,
    )
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                    NEWS                                    */
  /* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getNewsPreview({int page = 1}) {
    return _netUtil.get(path: 'v1/news/all?page=$page').then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                    EVENTS                                    */
  /* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getEventsPreview({int page = 1}) {
    return _netUtil
        .get(path: 'v2/event/collage/all?page=$page')
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

  /* -------------------------------------------------------------------------- */
  /*                                    WEATHER                                 */
  /* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getWeather() {
    return _netUtil
        .get(path: 'v2/weather/city')
        // .get(path: 'v2/event/collage/all?page=1')
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

/* -------------------------------------------------------------------------- */
/*                                   RANKING                                  */
/* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getRanking({int page = 1}) {
    return _netUtil
        .get(path: 'v1/international/ranking/all?page=$page')
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

/* -------------------------------------------------------------------------- */
/*                                   INVESTIGATIONS                           */
/* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getInvestigations({
    Map<String, dynamic> headers = const {
      "accessKey": "886D32B8F4841173DF763578BBE1C"
    },
  }) {
    return _netUtil
        .get(path: 'v1/indicators/all', headers: headers)
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

/* -------------------------------------------------------------------------- */
/*                                   Observatories                            */
/* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getObservatories({
    Map<String, dynamic> headers = const {
      "accessKey": "886D32B8F4841173DF763578BBE1C"
    },
  }) {
    return _netUtil
        .get(path: 'v1/observatory/all', headers: headers)
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

/* -------------------------------------------------------------------------- */
/*                                   GENERIC                                  */
/* -------------------------------------------------------------------------- */

  @override
  Future<ObservatoryDetailModel> getGenericObservatory({
    required String url,
    required String path,
  }) {
    return _netUtil.get(url: url, path: path).then((dynamic res) {
      return ObservatoryDetailModel.fromJson(res);
    });
  }

  @override
  Future<ApiResponseModel> getSubjectSchedule({
    required String username,
  }) {
    return _netUtil
        .get(
      url: 'https://srv-si-001.utpl.edu.ec/apim/mobile/api',
      path: 'services/app/HorarioPersona/GetPersonalSchedule?'
          'input=$username',
    )
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }

/* -------------------------------------------------------------------------- */
/*                              TV TEMPLATE BY CODE                           */
/* -------------------------------------------------------------------------- */

  @override
  Future<ApiResponseModel> getWallpaper({
    required Map<String, dynamic> body,
  }) {
    return _netUtil
        .post(
      path: 'v1/wallpaper/active/show',
      body: body,
    )
        .then((dynamic res) {
      return ApiResponseModel.fromJson(res);
    });
  }
}
