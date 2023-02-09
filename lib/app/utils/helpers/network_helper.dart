import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aad_oauth/helper/auth_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart' as get_package;
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:mime_type/mime_type.dart';
import 'package:dio/dio.dart';
import 'package:utpl_totem/app/data/enviroment.dart';
import 'package:utpl_totem/app/data/services/auth_service.dart';
import 'package:utpl_totem/app/utils/exceptions/http_exception.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

const String _endpoint = Environment.server;

class InterceptorToken extends InterceptorsWrapper {
  final Future<String> Function() userRoles;
  final Future<String> Function() awsToken;
  final Future<String> Function() deviceId;
  final Future<String> Function() msToken;

  InterceptorToken({
    required this.userRoles,
    required this.awsToken,
    required this.deviceId,
    required this.msToken,
  });

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    const whiteMsList = Environment.jwtMsAllowedDomains;
    const whiteAwsList = Environment.jwtAwsAllowedDomains;
    const whiteRolesList = Environment.rolesAllowedDomains;

    if (whiteMsList.contains(options.uri.host)) {
      options.headers.addAll({"apikey": await msToken()});
      options.headers.addAll({"device": await deviceId()});
    }

    if (whiteAwsList.contains(options.uri.host)) {
      if (!options.headers.containsKey("apikey")) {
        options.headers.addAll({"apikey": await awsToken()});
      }
    }

    if (whiteRolesList.contains(options.uri.host)) {
      if (!options.headers.containsKey("roles")) {
        options.headers.addAll({"roles": await userRoles()});
      }
    }

    handler.next(options);
  }
}

class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal() {
    _dio.interceptors.add(
      InterceptorToken(
        msToken: () async {
          var authStorage = AuthStorage(
            aOptions: const AndroidOptions(),
          );

          var cacheToken = await authStorage.loadTokenFromCache();

          if (!cacheToken.hasValidAccessToken() &&
              cacheToken.hasRefreshToken()) {
            var adfsAuth = ToolsHelper.adfsConfig;
            await adfsAuth.login(refreshIfAvailable: true);
          }

          cacheToken = await authStorage.loadTokenFromCache();

          if (cacheToken.hasValidAccessToken()) {
            var decodedToken = JWT.parse(cacheToken.accessToken ?? "");
            var issuedAt = DateTime.fromMillisecondsSinceEpoch(
                (decodedToken.issuedAt ?? 0) * 1000);
            var expiresAt = DateTime.fromMillisecondsSinceEpoch(
                (decodedToken.expiresAt ?? 0) * 1000);

            ToolsHelper.logger.i(
              "Token [login_adfs_service](getToken)",
              "${issuedAt.toString()} :: ${expiresAt.toString()}",
            );
          }

          final composeToken = '${cacheToken.accessToken}';
          return composeToken;
        },
        awsToken: () async {
          var token = await _authServiceInterface.getAwsToken();
          final composeToken = '$token';
          return (token != null && token.isNotEmpty) ? composeToken : '';
        },
        deviceId: () async {
          var deviceId = await _authServiceInterface.getDeviceId();
          return deviceId;
        },
        userRoles: () async {
          var roles = await _authServiceInterface.getUserRoles();
          final composeRoles =
              roles.map((role) => '"${role.code.toUpperCase()}"').join(',');
          return roles.isNotEmpty ? composeRoles : '';
        },
      ),
    );
  }
  factory NetworkUtil() => _instance;

  static BaseOptions options = BaseOptions(
    receiveTimeout: Environment.httpTimeout,
    connectTimeout: Environment.httpTimeout,
  );
  final Dio _dio = Dio(options);
  final _authServiceInterface = get_package.Get.put<AuthService>(AuthService());

  Future<dynamic> get({
    String url = _endpoint,
    String path = '',
    Map<String, dynamic> headers = const {},
  }) async {
    try {
      var res = await _dio.get(
        '$url/$path',
        options: Options(
          responseType: ResponseType.json,
          contentType: Headers.jsonContentType,
          headers: headers,
        ),
      );
      return res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        final int? statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            throw BadRequestException(e.response?.statusMessage.toString());
          case 401:
          case 403:
            throw UnauthorizedException(e.response?.statusMessage.toString());
          case 404:
            throw NotFoundException(e.response?.statusMessage.toString());
          case 500:
          default:
            throw FetchDataException(
                'Error occurred while Communication with Server with StatusCode : $statusCode');
        }
      } else {
        if ([
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.sendTimeout
        ].contains(e.type)) {
          throw TimeoutException('Tiempo de espera agotado');
        }
        if ([
          SocketException,
          HandshakeException,
        ].contains(e.error.runtimeType)) {
          throw SocketException(e.message);
        }
        throw FetchDataException(
            'Error occurred while Communication with Server ${e.requestOptions.baseUrl} with StatusCode : Error:${e.message}]');
      }
    }
  }

  Future<dynamic> post({
    String url = _endpoint,
    String path = '',
    dynamic body,
    Map<String, dynamic> headers = const {},
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      var res = await _dio.post(
        '$url/$path',
        data: body,
        options: Options(
          responseType: ResponseType.json,
          contentType: contentType,
          headers: headers,
        ),
      );
      return res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        final int? statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            throw BadRequestException(e.response?.statusMessage.toString());
          case 401:
          case 403:
            throw UnauthorizedException(e.response?.statusMessage.toString());
          case 404:
            throw NotFoundException(e.response?.statusMessage.toString());
          case 422:
            throw FetchDataException(statusCode.toString());
          case 500:
          default:
            throw FetchDataException(
                'Error occurred while Communication with Server with StatusCode : $statusCode');
        }
      } else {
        if ([
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.sendTimeout
        ].contains(e.type)) {
          throw TimeoutException('Tiempo de espera agotado');
        }
        if ([
          SocketException,
          HandshakeException,
        ].contains(e.error.runtimeType)) {
          throw SocketException(e.message);
        }
        throw FetchDataException(
            'Error occurred while Communication with Server ${e.requestOptions.baseUrl} with StatusCode : Error:${e.message}]');
      }
    }
  }

  Future<dynamic> put(
      {String url = _endpoint, String path = '', dynamic body}) async {
    try {
      var res = await _dio.put(
        '$url/$path',
        data: json.encode(body),
        options: Options(
          responseType: ResponseType.json,
          contentType: Headers.jsonContentType,
        ),
      );

      return res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        final int? statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            throw BadRequestException(e.response?.statusMessage.toString());
          case 401:
          case 403:
            throw UnauthorizedException(e.response?.statusMessage.toString());
          case 404:
            throw NotFoundException(e.response?.statusMessage.toString());
          case 500:
          default:
            throw FetchDataException(
                'Error occurred while Communication with Server with StatusCode : $statusCode');
        }
      } else {
        if ([
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.sendTimeout
        ].contains(e.type)) {
          throw TimeoutException('Tiempo de espera agotado');
        }
        if ([
          SocketException,
          HandshakeException,
        ].contains(e.error.runtimeType)) {
          throw SocketException(e.message);
        }
        throw FetchDataException(
            'Error occurred while Communication with Server ${e.requestOptions.baseUrl} with StatusCode : Error:${e.message}]');
      }
    }
  }

  Future<dynamic> patch(
      {String url = _endpoint, String path = '', dynamic body}) async {
    try {
      var res = await _dio.patch(
        '$url/$path',
        data: json.encode(body),
        options: Options(
          responseType: ResponseType.json,
          contentType: Headers.jsonContentType,
        ),
      );
      return res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        final int? statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            throw BadRequestException(e.response?.statusMessage.toString());
          case 401:
          case 403:
            throw UnauthorizedException(e.response?.statusMessage.toString());
          case 404:
            throw NotFoundException(e.response?.statusMessage.toString());
          case 500:
          default:
            throw FetchDataException(
                'Error occurred while Communication with Server with StatusCode : $statusCode');
        }
      } else {
        if ([
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.sendTimeout
        ].contains(e.type)) {
          throw TimeoutException('Tiempo de espera agotado');
        }
        if ([
          SocketException,
          HandshakeException,
        ].contains(e.error.runtimeType)) {
          throw SocketException(e.message);
        }
        throw FetchDataException(
            'Error occurred while Communication with Server ${e.requestOptions.baseUrl} with StatusCode : Error:${e.message}]');
      }
    }
  }

  Future<dynamic> uploadImage(File? image,
      {String url = _endpoint,
      String path = '',
      String imageField = 'image',
      dynamic body}) async {
    String fileName = image?.path.split('/').last ?? 'No image';

    FormData formData = FormData();

    body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    if (image != null) {
      String? mimeType = mime(image.path);
      mimeType ??= 'jpg';

      formData.files.add(
        MapEntry(
          imageField,
          await MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: MediaType('image', mimeType),
          ),
        ),
      );
    }

    try {
      var res = await _dio.post(
        '$url/$path',
        data: formData,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      return res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        final int? statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            throw BadRequestException(e.response?.statusMessage.toString());
          case 401:
          case 403:
            throw UnauthorizedException(e.response?.statusMessage.toString());
          case 404:
            throw NotFoundException(e.response?.statusMessage.toString());
          case 500:
          default:
            throw FetchDataException(
                'Error occurred while Communication with Server with StatusCode : $statusCode');
        }
      } else {
        if ([
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.sendTimeout
        ].contains(e.type)) {
          throw TimeoutException('Tiempo de espera agotado');
        }
        if ([
          SocketException,
          HandshakeException,
        ].contains(e.error.runtimeType)) {
          throw SocketException(e.message);
        }
        throw FetchDataException(
            'Error occurred while Communication with Server ${e.requestOptions.baseUrl} with StatusCode : Error:${e.message}]');
      }
    }
  }

  Future<dynamic> postFormData({
    String url = _endpoint,
    String path = '',
    required FormData body,
  }) async {
    try {
      var res = await _dio.post(
        '$url/$path',
        data: body,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      return res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        final int? statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            throw BadRequestException(e.response?.statusMessage.toString());
          case 401:
          case 403:
            throw UnauthorizedException(e.response?.statusMessage.toString());
          case 404:
            throw NotFoundException(e.response?.statusMessage.toString());
          case 500:
          default:
            throw FetchDataException(
                'Error occurred while Communication with Server with StatusCode : $statusCode');
        }
      } else {
        if ([
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.sendTimeout
        ].contains(e.type)) {
          throw TimeoutException('Tiempo de espera agotado');
        }
        if ([
          SocketException,
          HandshakeException,
        ].contains(e.error.runtimeType)) {
          throw SocketException(e.message);
        }
        throw FetchDataException(
            'Error occurred while Communication with Server ${e.requestOptions.baseUrl} with StatusCode : Error:${e.message}]');
      }
    }
  }

  Future<dynamic> uploadFile(File file,
      {String url = _endpoint,
      String path = '',
      String fileField = 'file',
      dynamic body}) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData();

    body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    String? mimeType = mime(file.path);
    mimeType ??= '.pdf';

    formData.files.add(
      MapEntry(
        fileField,
        await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType('file', mimeType),
        ),
      ),
    );

    try {
      var res = await _dio.post(
        '$url/$path',
        data: formData,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      return res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        final int? statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            throw BadRequestException(e.response?.statusMessage.toString());
          case 401:
          case 403:
            throw UnauthorizedException(e.response?.statusMessage.toString());
          case 404:
            throw NotFoundException(e.response?.statusMessage.toString());
          case 422:
            throw FetchDataException(statusCode.toString());
          case 500:
          default:
            throw FetchDataException(
                'Error occurred while Communication with Server with StatusCode : $statusCode');
        }
      } else {
        if ([
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.sendTimeout
        ].contains(e.type)) {
          throw TimeoutException('Tiempo de espera agotado');
        }
        if ([
          SocketException,
          HandshakeException,
        ].contains(e.error.runtimeType)) {
          throw SocketException(e.message);
        }
        throw FetchDataException(
            'Error occurred while Communication with Server ${e.requestOptions.baseUrl} with StatusCode : Error:${e.message}]');
      }
    }
  }

  Future<dynamic> updateWithImage(File? image,
      {String url = _endpoint,
      String path = '',
      String imageField = 'image',
      dynamic body}) async {
    FormData formData = FormData();

    body.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    if (image != null) {
      String fileName = image.path.split('/').last;
      String? mimeType = mime(image.path);

      mimeType ??= 'jpg';

      formData.files.add(
        MapEntry(
          imageField,
          await MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: MediaType('image', mimeType),
          ),
        ),
      );
    }

    try {
      var res = await _dio.put(
        '$url/$path',
        data: formData,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      return res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        final int? statusCode = e.response?.statusCode;

        switch (statusCode) {
          case 400:
            throw BadRequestException(e.response?.statusMessage.toString());
          case 401:
          case 403:
            throw UnauthorizedException(e.response?.statusMessage.toString());
          case 404:
            throw NotFoundException(e.response?.statusMessage.toString());
          case 500:
          default:
            throw FetchDataException(
                'Error occurred while Communication with Server with StatusCode : $statusCode');
        }
      } else {
        if ([
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
          DioErrorType.sendTimeout
        ].contains(e.type)) {
          throw TimeoutException('Tiempo de espera agotado');
        }
        if ([
          SocketException,
          HandshakeException,
        ].contains(e.error.runtimeType)) {
          throw SocketException(e.message);
        }
        throw FetchDataException(
            'Error occurred while Communication with Server ${e.requestOptions.baseUrl} with StatusCode : Error:${e.message}]');
      }
    }
  }
}
