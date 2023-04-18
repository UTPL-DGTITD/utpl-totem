import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:utpl_totem/app/data/models/roles_model.dart';
import 'package:utpl_totem/app/data/models/user_profile_model.dart';
import 'package:utpl_totem/app/data/repositories/local_repository.dart';
import 'package:utpl_totem/app/utils/helpers/tools_helper.dart';

class LocalProvider extends LocalRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> saveUsername({required String username}) async {
    await _storage
        .write(key: "username", value: username)
        .catchError((onError) {
      ToolsHelper.logger.e("saveUsername", onError);
    });
    return;
  }

  @override
  Future<void> saveCacheValue({
    required String key,
    required Map<String, dynamic> content,
  }) async {
    var contentStr = json.encode(content);
    await _storage.write(key: key, value: contentStr).catchError((onError) {
      ToolsHelper.logger.e("saveCacheValue", onError);
    });
    return;
  }

  @override
  Future<String> getUsername() async {
    try {
      final String? user = await _storage.read(key: 'username');

      return user == null || user.isEmpty ? "undefined" : user;
    } catch (e) {
      return "undefined";
    }
  }

  @override
  Future<String> getSingleValue({required String key}) async {
    try {
      final String? value = await _storage.read(key: key);

      return value == null || value.isEmpty ? "undefined" : value;
    } catch (e) {
      return "undefined";
    }
  }

  @override
  Future<void> saveUserProfile({required UserProfileModel? data}) async {
    await _storage
        .write(
            key: "user_profile",
            value: data != null ? userProfileModelToJson(data) : null)
        .catchError((onError) {
      FirebaseCrashlytics.instance.recordError(onError, null,
          reason: '[local_provider] (saveUserProfile)');
      ToolsHelper.logger.e("save user_profile", onError);
    });
    return;
  }

  @override
  Future<UserProfileModel?> getUserProfile() async {
    try {
      final String? userProfile = await _storage.read(key: 'user_profile');

      return userProfile != null ? userProfileModelFromJson(userProfile) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveRoles({required List<RolesModel> data}) async {
    await _storage
        .write(key: "user_roles", value: rolesModelListToJson(data))
        .catchError((onError) {
      FirebaseCrashlytics.instance
          .recordError(onError, null, reason: '[local_provider] (saveRoles)');
      ToolsHelper.logger.e("save user_roles", onError);
    });
    return;
  }

  @override
  Future<List<RolesModel>> getRoles() async {
    final guestRole = RolesModel(
      code: "GS_Invitados",
      name: "Invitado",
      priority: 0,
    );

    try {
      final String? userRoles = await _storage.read(key: 'user_roles');

      if (userRoles != null) {
        var roles = rolesModelListFromJson(userRoles);
        roles.isEmpty ? roles.add(guestRole) : null;
        return roles;
      } else {
        return [guestRole];
      }
    } catch (e) {
      return [guestRole];
    }
  }

  @override
  Future<int> getSkipIntro() async {
    try {
      final String? value = await _storage.read(key: 'skip_intro');

      return value == null || value.isEmpty ? 0 : (int.tryParse(value) ?? 0);
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> saveSkipIntro({required int skip}) async {
    await _storage
        .write(key: "skip_intro", value: skip.toString())
        .catchError((onError) {
      FirebaseCrashlytics.instance.recordError(onError, null,
          reason: '[local_provider] (saveSkipIntro)');
      ToolsHelper.logger.e("saveSkipIntro", onError);
    });
    return;
  }

  @override
  Future<String> getBetaCode() async {
    try {
      final String? value = await _storage.read(key: 'beta_code');

      return value == null || value.isEmpty ? "" : value;
    } catch (e) {
      return "";
    }
  }

  @override
  Future<void> saveBetaCode({required String code}) async {
    await _storage
        .write(key: "beta_code", value: code.toString())
        .catchError((onError) {
      FirebaseCrashlytics.instance.recordError(onError, null,
          reason: '[local_provider] (saveBetaCode)');
      ToolsHelper.logger.e("saveBetaCode", onError);
    });
    return;
  }

  @override
  Future<String> getDeviceId() async {
    try {
      final String? value = await _storage.read(key: 'device_id');

      return value == null || value.isEmpty ? "" : value;
    } catch (e) {
      return "";
    }
  }

  @override
  Future<void> saveDeviceId({required String id}) async {
    await _storage
        .write(key: "device_id", value: id.toString())
        .catchError((onError) {
      FirebaseCrashlytics.instance.recordError(onError, null,
          reason: '[local_provider] (saveDeviceId)');
      ToolsHelper.logger.e("saveDeviceId", onError);
    });
    return;
  }

  @override
  Future<bool> getSkipVersion({required String appVersion}) async {
    final prefs = await _storage.read(key: 'skip_version');
    if (prefs != null) {
      if (prefs == appVersion) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> saveSkipVersion({required String appVersion}) async {
    await _storage
        .write(key: 'skip_version', value: appVersion.toString())
        .catchError((onError) {
      FirebaseCrashlytics.instance.recordError(onError, null,
          reason: '[local_provider] (saveSkipVersion)');
      ToolsHelper.logger.e("saveSkipVersion", onError);
    });
    return;
  }

  @override
  Future<void> showAll({required String page}) async {
    var all = await _storage.readAll();
    ToolsHelper.logger.v(all, page);
    return;
  }
}
