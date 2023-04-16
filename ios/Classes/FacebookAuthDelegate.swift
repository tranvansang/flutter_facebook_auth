class FacebookAuthDelegate: NSObject {
    let loginManager : LoginManager = LoginManager()
    var pendingResult: FlutterResult? = nil

    public func login(permissions: [String], flutterResult: @escaping FlutterResult) {
        let isOK = setPendingResult(methodName: "login", flutterResult: flutterResult)
        if(!isOK){
            return
        }


        let viewController: UIViewController = (mainWindow?.rootViewController)!

        loginManager.logIn(permissions: permissions, from: viewController, handler: { (result,error)->Void in
            if error != nil{
                self.finishWithError(errorCode: "FAILED", message: error!.localizedDescription)
            }else if result!.isCancelled{
                self.finishWithError(errorCode: "CANCELLED", message: "User has cancelled login with facebook")
            }else{
                self.finishWithResult(data:self.getAccessToken(accessToken:  result!.token! ))
            }
        })
    }
    public func logout(result: @escaping FlutterResult) {
        loginManager.logOut()
        result(nil)
    }
}
