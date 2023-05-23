import 'package:flutter/services.dart';

class FacebookAuth {
  final methodChannel =
      const MethodChannel('me.transang.plugins.facebook_auth/channel');
  FacebookAuth._internal();
  static final _instance = FacebookAuth._internal();
  factory FacebookAuth() => _instance;

  /// @return {
  ///  'token': String
  ///  'userId': String
  ///  'expires': int // timeIntervalSince1970 * 1000
  ///  'applicationId': String
  ///  'lastRefresh': int // timeIntervalSince1970 * 1000
  ///  'isExpired': Boolean
  ///  'grantedPermissions': List<String>
  ///  'declinedPermissions': List<String>
  ///  'dataAccessExpirationTime': int // timeIntervalSince1970 * 1000
  /// }
  Future<Map<String, dynamic>> login(List<String> permissions) async {
    return await methodChannel.invokeMethod('login', {
      'permissions': permissions,
    });
  }

  Future<void> logout() async {
    await methodChannel.invokeMethod('logout');
  }
}
