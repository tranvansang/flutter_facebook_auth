import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'facebook_auth_platform_interface.dart';

/// An implementation of [FacebookAuthPlatform] that uses method channels.
class MethodChannelFacebookAuth extends FacebookAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('facebook_auth');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
