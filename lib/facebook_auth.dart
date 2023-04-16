import 'package:flutter/services.dart';

class FacebookAuth {
  final methodChannel =
      const MethodChannel('me.transang.plugins.facebook_auth/channel');
  FacebookAuth._internal();
  static final _instance = FacebookAuth._internal();
  factory FacebookAuth() => _instance;

  Future<String> signIn(String clientId) async {
    return await methodChannel.invokeMethod('signIn', {
      'clientId': clientId,
    });
  }

  Future<void> signOut() async {
    await methodChannel.invokeMethod('signOut');
  }
}
