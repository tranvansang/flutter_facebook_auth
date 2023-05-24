# facebook_auth

Simple facebook authentication plugin for flutter.

# Configuration

Suppose your facebook app id is `1234567890`, client token is `abcde12345`, and app name is `My App`.

## Android
Official docs: https://developers.facebook.com/docs/facebook-login/android/

Define the following string resources in `android/app/src/main/res/values/strings.xml`:
```xml
<string name="facebook_app_id">1234567890</string>
<string name="fb_login_protocol_scheme">fb1234567890</string>
<string name="facebook_client_token">abcde12345</string>
```


In `AndroidManifest.xml`:

```xml
<manifest {...}>
  <uses-permission android:name="android.permission.INTERNET"/>
  <application {...}>
    <!--		facebook app id and token-->
    <meta-data android:name="com.facebook.sdk.ApplicationId" android:value="@string/facebook_app_id"/>
    <meta-data android:name="com.facebook.sdk.ClientToken" android:value="@string/facebook_client_token"/>
            <!--		facebook Chrome Custom Tabs-->
    <activity android:name="com.facebook.FacebookActivity"
              android:configChanges=
                      "keyboard|keyboardHidden|screenLayout|screenSize|orientation"
              android:label="${appName}" />
    <activity
    android:name="com.facebook.CustomTabActivity"
    android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="@string/fb_login_protocol_scheme" />
      </intent-filter>
    </activity>
    <!--		facebook Chrome Custom Tabs end-->
    <!--		facebook end-->
  </application>
</manifest>
```

## iOS

Official docs: https://developers.facebook.com/docs/facebook-login/ios/

In `info.plist` add the following:

```xml
<key>CFBundleURLTypes</key>
<array>
<dict>
  <key>CFBundleURLSchemes</key>
  <array>
    <string>fb1234567890</string>
  </array>
</dict>
</array>
<key>FacebookAppID</key>
<string>1234567890</string>
<key>FacebookClientToken</key>
<string>abcde12345</string>
<key>FacebookDisplayName</key>
<string>My App</string>
<key>LSApplicationQueriesSchemes</key>
<array>
<string>fbapi</string>
<string>fb-messenger-share-api</string>
</array>
```

# Usage

- Add the plugin to `pubspec.yaml`: `flutter pub add facebook_auth`.
- Import the plugin in your dart code: `import 'package:facebook_auth/facebook_auth.dart';`.
- To authenticate user: `Facebook().login(permissions)` with `permissions: List<string>` being the permission list, for example `['public_profile', 'email']`.
  This function returns a `Future` object resolving a map of the following type:
```
{
  'token': String
  'userId': String
  'expires': int // timeIntervalSince1970 * 1000 (in milisec)
  'applicationId': String
  'lastRefresh': int // timeIntervalSince1970 * 1000 (in milisec)
  'isExpired': Boolean
  'grantedPermissions': List<String>
  'declinedPermissions': List<String>
  'dataAccessExpirationTime': int // timeIntervalSince1970 * 1000 (in milisec)
}
```
- To logout user: `FacebookAuth().logout(): Future<void>`.
- Possible error code: check the error code with
```flutter
try {
  return {'idToken': await FacebookAuth().login(permissions)};
} on PlatformException catch (e) {
  if (e.code == 'USER_CANCELLED') {
    throw AppError('User has cancelled');
  }
  rethrow;
}
```
- For iOS: see https://github.com/tranvansang/flutter_facebook_auth/tree/master/ios/Classes/FacebookAuthDelegate.swift#L5
- For Android: see https://github.com/tranvansang/flutter_facebook_auth/tree/master/android/src/main/kotlin/me/transang/plugins/facebook_auth/FacebookAuthDelegate.kt#L19

# SDK versions
- Android
```
    implementation 'com.facebook.android/facebook-login:16.0.1'
//    implementation 'com.facebook.android:facebook-login:latest.release'
```

- iOS
```
  s.dependency 'FBSDKCoreKit', '~> 16.1'
  s.dependency 'FBSDKLoginKit', '~> 16.1'
  s.dependency 'FBSDKShareKit', '~> 16.1'
```
