import 'package:flutter/services.dart';

class FacebookAuth {
  final methodChannel =
      const MethodChannel('me.transang.plugins.facebook_auth/channel');
  FacebookAuth._internal();
  static final _instance = FacebookAuth._internal();
  factory FacebookAuth() => _instance;

  Future<dynamic> login(List<String> permissions) async {
    return await methodChannel.invokeMethod('login', {
      'permissions': permissions,
    });
  }

  Future<void> logout() async {
    await methodChannel.invokeMethod('logout');
  }
}
