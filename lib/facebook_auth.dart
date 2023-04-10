
import 'facebook_auth_platform_interface.dart';

class FacebookAuth {
  Future<String?> getPlatformVersion() {
    return FacebookAuthPlatform.instance.getPlatformVersion();
  }
}
