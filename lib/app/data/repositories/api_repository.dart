import 'package:utpl_totem/app/data/models/api_response_model.dart';
import 'package:utpl_totem/app/data/models/observatory_detail_model.dart';

abstract class ApiRepository {
  /* -------------------------------------------------------------------------- */
  /*                                   STATUS                                   */
  /* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getBackendStatus();

  /* -------------------------------------------------------------------------- */
  /*                                  SERVICES                                  */
  /* -------------------------------------------------------------------------- */
  Future<ApiResponseModel> getServicesPaginated({int page = 1});

  Future<ApiResponseModel> addCountService({required String idService});

  /* -------------------------------------------------------------------------- */
  /*                                   BANNER                                   */
  /* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getBannersAvailable();

/* -------------------------------------------------------------------------- */
/*                              ACADEMIC CALENDAR MODALITIES                  */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getAcademicCalendarModalities();

/* -------------------------------------------------------------------------- */
/*                              ACADEMIC CALENDAR ACTIVITIES BY MODALITY      */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getActivitiesByModality({
    required String idModality,
  });

/* -------------------------------------------------------------------------- */
/*                              TV TEMPLATES                                  */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getTvTemplates();

/* -------------------------------------------------------------------------- */
/*                              TV TEMPLATE BY CODE                           */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getTvTemplateByCode({
    required Map<String, dynamic> body,
  });

/* -------------------------------------------------------------------------- */
/*                                    NEWS                                    */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getNewsPreview({int page = 1});

/* -------------------------------------------------------------------------- */
/*                                    NEWS                                    */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getEventsPreview({int page = 1});

/* -------------------------------------------------------------------------- */
/*                                    WEATHER                                 */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getWeather();

/* -------------------------------------------------------------------------- */
/*                                   RANKING                                  */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getRanking({int page = 1});

/* -------------------------------------------------------------------------- */
/*                                   INVESTIGATIONS                           */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getInvestigations({
    Map<String, dynamic> headers,
  });

/* -------------------------------------------------------------------------- */
/*                                   OBSERVATORIES                            */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getObservatories({
    Map<String, dynamic> headers,
  });

  /* -------------------------------------------------------------------------- */
  /*                                   GENERIC                                  */
  /* -------------------------------------------------------------------------- */

  Future<ObservatoryDetailModel> getGenericObservatory({
    required String url,
    required String path,
  });
}
