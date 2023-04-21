import 'package:get/get.dart';
import 'package:utpl_totem/app/data/models/end_point_base_model.dart';
import 'package:utpl_totem/app/data/providers/local_provider.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';

class UriHelper {
  static Future<Map<String, dynamic>> composeEndPoint(
    EndPointBaseModel? endPoint, {
    int? page,
  }) async {
    final LocalRepository localRepository = Get.put(LocalProvider());

    Map<String, dynamic> result = {
      "url_base": "",
      "url_path": "",
      "headers": {},
    };

    if (endPoint == null) {
      return result;
    }

    String urlBase = endPoint.urlBase;
    String urlBody = endPoint.urlPath;
    String urlPath = "${endPoint.version}$urlBody";
    Map<String, String> queryParams = {};
    Map<String, dynamic> headers = {};

    // Replace path variable values in urlPath
    for (var pathVar in endPoint.pathVariables) {
      switch (pathVar.type) {
        case "default":
          urlPath =
              urlPath.replaceAll(pathVar.name, pathVar.defaultValue.toString());
          break;
        case "localstorage":
          String localValue =
              await localRepository.getSingleValue(key: pathVar.value ?? "");
          urlPath = urlPath.replaceAll(pathVar.name, localValue);
          break;
        case "body":
          urlPath = urlPath.replaceAll(pathVar.name, pathVar.value.toString());
          break;
        default:
      }
    }

    // Generate query params with data from endPoint
    for (var queryParam in endPoint.queryParams) {
      switch (queryParam.type) {
        case "default":
          if (queryParam.name == "page" || queryParam.name == "pageNo") {
            queryParams[queryParam.name] = page != null
                ? page.toString()
                : queryParam.defaultValue.toString();
          } else {
            queryParams[queryParam.name] = queryParam.defaultValue.toString();
          }

          break;
        case "localstorage":
          String localValue =
              await localRepository.getSingleValue(key: queryParam.value ?? "");
          queryParams[queryParam.name] = localValue.toString();
          break;
        case "body":
          queryParams[queryParam.name] = queryParam.value ?? "";
          break;
        default:
      }
    }

    String queryParamsStr = Uri(queryParameters: queryParams).query;
    String composedPath =
        queryParamsStr.isNotEmpty ? "$urlPath?$queryParamsStr" : urlPath;

    if (endPoint.headers != null) {
      headers = endPoint.headers!;
    }
    result["url_base"] = urlBase;
    result["url_path"] = composedPath;
    result["headers"] = headers;

    return result;
  }
}
