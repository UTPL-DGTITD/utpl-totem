// import 'dart:async';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:aad_oauth/helper/auth_storage.dart';
// import 'package:corsac_jwt/corsac_jwt.dart';
// import 'package:get/get.dart';
// import 'package:utpl_totem_oficial/app/data/models/roles_model.dart';
// import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

// class AuthService extends GetxService {
//   final loggedStream = StreamController<bool>.broadcast();
//   final storage = const FlutterSecureStorage();

//   Stream<bool> get stream => loggedStream.stream;

//   Future<bool> isAuth() async {
//     var authStorage = AuthStorage(aOptions: const AndroidOptions());

//     var cacheToken = await authStorage.loadTokenFromCache();

//     if (!cacheToken.hasValidAccessToken() && cacheToken.hasRefreshToken()) {
//       var adfsAuth = ToolsHelper.adfsConfig;
//       await adfsAuth.login(refreshIfAvailable: true);
//     }

//     cacheToken = await authStorage.loadTokenFromCache();

//     if (cacheToken.hasValidAccessToken()) {
//       var decodedToken = JWT.parse(cacheToken.accessToken ?? "");
//       var issuedAt = DateTime.fromMillisecondsSinceEpoch(
//           (decodedToken.issuedAt ?? 0) * 1000);
//       var expiresAt = DateTime.fromMillisecondsSinceEpoch(
//           (decodedToken.expiresAt ?? 0) * 1000);

//       ToolsHelper.logger.i(
//         "Token [auth_service](isAuth)",
//         "${issuedAt.toString()} :: ${expiresAt.toString()}",
//       );
//     }

//     final token = cacheToken.accessToken;

//     var validator = JWTValidator();

//     if (token != null) {
//       var decodedToken = JWT.parse(token);

//       Set<String> errors = validator.validate(decodedToken);
//       if (errors.isNotEmpty) {
//         return false;
//       } else {
//         return true;
//       }
//     } else {
//       return false;
//     }
//   }

//   Future<void> setToken(String token) async {
//     await storage.write(key: 'token', value: token);
//     return;
//   }

//   Future<void> deleteToken() async {
//     await storage.delete(key: 'token');
//     return;
//   }

//   Future<String?> getToken() async {
//     final String? token = await storage.read(key: 'token');
//     return token;
//   }

//   Future<void> setAwsToken(String token) async {
//     await storage.write(key: 'token-aws', value: token);
//     return;
//   }

//   Future<void> deleteAwsToken() async {
//     await storage.delete(key: 'token-aws');
//     return;
//   }

//   Future<String?> getAwsToken() async {
//     final String? token = await storage.read(key: 'token-aws');
//     return token;
//   }

//   Future<List<RolesModel>> getUserRoles() async {
//     final guestRole = RolesModel(
//       code: "GS_Invitados",
//       name: "Invitado",
//       priority: 0,
//     );

//     try {
//       final String? userRoles = await storage.read(key: 'user_roles');

//       if (userRoles != null) {
//         var roles = rolesModelListFromJson(userRoles);
//         roles.isEmpty ? roles.add(guestRole) : null;
//         return roles;
//       } else {
//         return [guestRole];
//       }
//     } catch (e) {
//       return [guestRole];
//     }
//   }

//   Future<Map<String, String>> getAll() async {
//     final Map<String, String> token = await storage.readAll();
//     return token;
//   }

//   Future<void> restoreAll(Map<String, String> values) async {
//     values.forEach((key, value) async {
//       if (key != 'Token') {
//         await storage.write(key: key, value: value);
//       }
//     });

//     return;
//   }

//   Future<void> deleteMsToken() async {
//     await storage.delete(key: 'Token');
//     return;
//   }

//   Future<String> getDeviceId() async {
//     try {
//       final String? value = await storage.read(key: 'device_id');

//       return value == null || value.isEmpty ? "" : value;
//     } catch (e) {
//       return "";
//     }
//   }
// }
