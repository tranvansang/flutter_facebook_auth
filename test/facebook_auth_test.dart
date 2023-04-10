import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_auth/facebook_auth.dart';
import 'package:facebook_auth/facebook_auth_platform_interface.dart';
import 'package:facebook_auth/facebook_auth_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFacebookAuthPlatform
    with MockPlatformInterfaceMixin
    implements FacebookAuthPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FacebookAuthPlatform initialPlatform = FacebookAuthPlatform.instance;

  test('$MethodChannelFacebookAuth is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFacebookAuth>());
  });

  test('getPlatformVersion', () async {
    FacebookAuth facebookAuthPlugin = FacebookAuth();
    MockFacebookAuthPlatform fakePlatform = MockFacebookAuthPlatform();
    FacebookAuthPlatform.instance = fakePlatform;

    expect(await facebookAuthPlugin.getPlatformVersion(), '42');
  });
}
