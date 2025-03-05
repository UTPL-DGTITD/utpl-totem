import 'package:utpl_totem_oficial/app/data/models/api_response_model.dart';
import 'package:utpl_totem_oficial/app/data/models/observatory_detail_model.dart';

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

  /* -------------------------------------------------------------------------- */
  /*                                   CHECK SCHEDULE                           */
  /* -------------------------------------------------------------------------- */
  Future<ApiResponseModel> getSubjectSchedule({
    required Map<String, dynamic> body,
    Map<String, dynamic> headers,
  });

  /* -------------------------------------------------------------------------- */
  /*                                   GET WALLPAPER                            */
  /* -------------------------------------------------------------------------- */
  Future<ApiResponseModel> getWallpaper({
    required Map<String, dynamic> body,
  });

  /* -------------------------------------------------------------------------- */
  /*                                   GET BUILDINGS                            */
  /* -------------------------------------------------------------------------- */
  Future<ApiResponseModel> getBuildings({
    int page = 1,
    Map<String, dynamic> headers,
  });

  /* -------------------------------------------------------------------------- */
  /*                                   GET CLASSROOMS                            */
  /* -------------------------------------------------------------------------- */
  Future<ApiResponseModel> getClassrooms({
    required String buildingCode,
    int page = 1,
    Map<String, dynamic> headers,
  });

  /* -------------------------------------------------------------------------- */
  /*                                   GET CLASSROOM SCHEDULE                   */
  /* -------------------------------------------------------------------------- */
  Future<ApiResponseModel> getClassroomSchedule({
    required Map<String, dynamic> body,
    Map<String, dynamic> headers,
  });

  /* -------------------------------------------------------------------------- */
  /*                                   GET NOTIFY                               */
  /* -------------------------------------------------------------------------- */
  Future<ApiResponseModel> getNotify({
    String idDevice = '',
  });

/* -------------------------------------------------------------------------- */
/*                                    GET FLICKER VIDEO IMG                   */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> getFlickerVideoImage({
    required String id,
    required String media,
    required String quality,
  });

  Future<ApiResponseModel> getAlbumsFlicker({int page = 1});

  Future<ApiResponseModel> getFlickerByAlbum(
      {required String idAlbum, int page = 1});

/* -------------------------------------------------------------------------- */
/*                               BUSES UTPL                                   */
/* -------------------------------------------------------------------------- */

  Future<ApiResponseModel> postBusesRoutesByWeekDay({
    required int weekDay,
  });

  Future<ApiResponseModel> showBusRoute({
    required String id,
  });
}
