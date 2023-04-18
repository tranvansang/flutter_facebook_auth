import FBSDKCoreKit
import class FBSDKLoginKit.LoginManager
import Flutter

let ERR_PARAM_REQUIRED = "PARAM_REQUIRED"
let ERR_META_OPERATION_IN_PROGRESS = "META_OPERATION_IN_PROGRESS"
let ERR_OTHER = "OTHER"

let ERR_USER_CANCELLED = "USER_CANCELLED"
let ERR_OPERATION_FAIL = "OPERATION_FAIL"


class FacebookAuthDelegate: NSObject {
	let loginManager : FBSDKLoginKit.LoginManager = FBSDKLoginKit.LoginManager()
	private var mainWindow: UIWindow? {
		if let applicationWindow = UIApplication.shared.delegate?.window ?? nil {
			return applicationWindow
		}
		
		if #available(iOS 13.0, *) {
			if let scene = UIApplication.shared.connectedScenes.first(where: { $0.session.role == .windowApplication }),
				 let sceneDelegate = scene.delegate as? UIWindowSceneDelegate,
				 let window = sceneDelegate.window as? UIWindow  {
				return window
			}
		}
		
		return nil
	}
	
	
	public func login(permissions: [String], result: @escaping Flutter.FlutterResult) {
		if (!setup(result: result)) {
			return
		}
		
		let viewController: UIViewController = (mainWindow?.rootViewController)!
		
		loginManager.logIn(permissions: permissions, from: viewController, handler: { [self] (result,error)->Void in
			guard error == nil else {
				return finish(code: ERR_OPERATION_FAIL, message: error!.localizedDescription)
			}
			guard !result!.isCancelled else {
				return finish(code: ERR_USER_CANCELLED, message: "User has cancelled login with facebook")
			}
			finish(value: getAccessToken(accessToken:  result!.token! ))
		})
	}
	public func logout(result: @escaping FlutterResult) {
		if (!setup(result: result)) {
			return
		}
		loginManager.logOut()
		finish(value: true)
	}
	
	private func getAccessToken(accessToken: AccessToken) -> [String : Any] {
		let data = [
			"token": accessToken.tokenString,
			"userId": accessToken.userID,
			"expires": Int64((accessToken.expirationDate.timeIntervalSince1970*1000).rounded()),
			"lastRefresh":Int64((accessToken.refreshDate.timeIntervalSince1970*1000).rounded()),
			"applicationId":accessToken.appID,
			"isExpired":accessToken.isExpired,
			"grantedPermissions":accessToken.permissions.map {item in item.name},
			"declinedPermissions":accessToken.declinedPermissions.map {item in item.name},
			"dataAccessExpirationTime":Int64((accessToken.dataAccessExpirationDate.timeIntervalSince1970*1000).rounded()),
		] as [String : Any]
		return data;
	}
	
	// result consumer BEGIN
	var result: FlutterResult? = nil
	private func setup(result: @escaping FlutterResult) -> Bool {
		guard self.result == nil else {
			result(FlutterError(code: ERR_META_OPERATION_IN_PROGRESS, message: "Operation in progress", details: nil))
			return false
		}
		self.result = result
		return true
	}
	private func finish(value: Any) {
		guard result != nil else {
			return NSLog("Operation is already done")
		}
		result!(value)
		result = nil
	}
	private func finish(code: String, message: String, details: Any? = nil) {
		guard result != nil else {
			return NSLog("Operation is already done")
		}
		result!(FlutterError(code: code, message: message, details: details))
		result = nil
	}
	// result consumer END
}
