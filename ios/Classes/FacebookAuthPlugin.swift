import Flutter
import UIKit

import FBSDKCoreKit

public class FacebookAuthPlugin: NSObject, FlutterPlugin {
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
	let delegate = FacebookAuthDelegate()

	public static func register(with registrar: FlutterPluginRegistrar) {
        ApplicationDelegate.initialize()
		let channel = FlutterMethodChannel(name:"me.transang.plugins.facebook_auth/channel", binaryMessenger: registrar.messenger())
		let instance = FacebookAuthPlugin()
        registrar.addApplicationDelegate(instance)
		registrar.addMethodCallDelegate(instance, channel: channel)
	}

	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		let args = call.arguments as? [String: Any]

		switch call.method {

		case "login":
            delegate.login(permissions: args?["permissions"] as! [String], result: result)
			break
		case "logout":
			delegate.logout(result: result)
			break
		default:
			result(FlutterMethodNotImplemented)
			break
		}
	}

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        var options = [UIApplication.LaunchOptionsKey: Any]()
        for (k, value) in launchOptions {
            let key = k as! UIApplication.LaunchOptionsKey
            options[key] = value
        }
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: options)
        return true
    }

    public func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        let processed = ApplicationDelegate.shared.application(
            app, open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return processed;
    }
}
