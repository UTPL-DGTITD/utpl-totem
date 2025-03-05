import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:utpl_totem_oficial/app/data/models/roles_model.dart';
import 'package:utpl_totem_oficial/app/data/models/user_profile_model.dart';
import 'package:utpl_totem_oficial/app/data/repositories/local_repository.dart';
import 'package:utpl_totem_oficial/app/utils/helpers/tools_helper.dart';

class LocalProvider extends LocalRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> saveUsername({required String username}) async {
    await _storage
        .write(key: "username", value: username)
        .catchError((onError) {
      ToolsHelper.logger.e("saveUsername", error: onError);
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
      ToolsHelper.logger.e("saveCacheValue", error: onError);
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
      ToolsHelper.logger.e("save user_profile", error: onError);
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
      ToolsHelper.logger.e("save user_roles", error: onError);
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
      ToolsHelper.logger.e("saveSkipIntro", error: onError);
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
      ToolsHelper.logger.e("saveBetaCode", error: onError);
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
      ToolsHelper.logger.e("saveDeviceId", error: onError);
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
      ToolsHelper.logger.e("saveSkipVersion", error: onError);
    });
    return;
  }

  @override
  Future<void> showAll({required String page}) async {
    var all = await _storage.readAll();
    ToolsHelper.logger.v(all, error: page);
    return;
  }
}
