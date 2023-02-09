import 'package:utpl_totem/app/data/models/roles_model.dart';
import 'package:utpl_totem/app/data/models/user_profile_model.dart';

abstract class LocalRepository {
  Future<void> saveUsername({required String username});
  Future<String> getUsername();
  Future<void> saveCacheValue(
      {required String key, required Map<String, dynamic> content});
  Future<String> getSingleValue({required String key});
  Future<void> saveUserProfile({required UserProfileModel? data});
  Future<UserProfileModel?> getUserProfile();
  Future<void> saveRoles({required List<RolesModel> data});
  Future<List<RolesModel>> getRoles();
  Future<void> saveSkipIntro({required int skip});
  Future<int> getSkipIntro();
  Future<String> getBetaCode();
  Future<void> saveBetaCode({required String code});
  Future<String> getDeviceId();
  Future<void> saveDeviceId({required String id});
  Future<bool> getSkipVersion({required String appVersion});
  Future<void> saveSkipVersion({required String appVersion});
  Future<void> showAll({required String page});
}
