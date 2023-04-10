import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_auth/facebook_auth_method_channel.dart';

void main() {
  MethodChannelFacebookAuth platform = MethodChannelFacebookAuth();
  const MethodChannel channel = MethodChannel('facebook_auth');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
