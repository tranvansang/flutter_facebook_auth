import FBSDKCoreKit
import class FBSDKLoginKit.LoginManager
import Flutter

class FacebookAuthDelegate: NSObject {
	let loginManager : FBSDKLoginKit.LoginManager = FBSDKLoginKit.LoginManager()
	var pendingResult: Flutter.FlutterResult? = nil
	
	public func login(permissions: [String], result: @escaping Flutter.FlutterResult) {
//		let isOK = setPendingResult(methodName: "login", flutterResult: flutterResult)
//		if(!isOK){
//			return
//		}
		
		
//		let viewController: UIViewController = (mainWindow?.rootViewController)!
		
//		loginManager.logIn(permissions: permissions, from: viewController, handler: { (result,error)->Void in
//			if error != nil{
//				self.finish(errorCode: "FAILED", message: error!.localizedDescription)
//			}else if result!.isCancelled{
//				self.finish(errorCode: "CANCELLED", message: "User has cancelled login with facebook")
//			}else{
//				self.finishWithResult(data:self.getAccessToken(accessToken:  result!.token! ))
//			}
//		})
	}
	public func logout(result: @escaping FlutterResult) {
		loginManager.logOut()
		result(nil)
	}
}
