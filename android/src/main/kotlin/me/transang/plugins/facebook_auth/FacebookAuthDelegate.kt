package me.transang.plugins.facebook_auth

import android.app.Activity
import com.facebook.AccessToken
import com.facebook.CallbackManager
import com.facebook.FacebookCallback
import com.facebook.FacebookException
import com.facebook.login.LoginManager
import com.facebook.login.LoginResult
import io.flutter.plugin.common.MethodChannel

class FacebookAuthDelegate(
	private val activity: Activity,
	callbackManager: CallbackManager
) {
	private val loginManager = LoginManager.getInstance()
	private var resultConsumer: ResultConsumer<Any>? = null

	init {
		loginManager.registerCallback(callbackManager, object : FacebookCallback<LoginResult> {
			override fun onCancel() {
				resultConsumer?.throwError(Exception("User cancelled the operation"))
			}

			override fun onError(error: FacebookException) {
				resultConsumer?.throwError(error)
			}

			override fun onSuccess(result: LoginResult) {
				resultConsumer?.consume(resultFromAccessToken(result.accessToken))
			}
		})
	}

	fun resultFromAccessToken(accessToken: AccessToken): HashMap<String, Any> {
		val ret = HashMap<String, Any>()
		ret["token"] = accessToken.token
		ret["userId"] = accessToken.userId
		ret["expires"] = accessToken.expires.time
		ret["applicationId"] = accessToken.applicationId
		ret["lastRefresh"] = accessToken.lastRefresh.time
		ret["isExpired"] = accessToken.isExpired
		ret["grantedPermissions"] = accessToken.permissions
		ret["declinedPermissions"] = accessToken.declinedPermissions
		ret["dataAccessExpirationTime"] = accessToken.dataAccessExpirationTime.time

		return ret
	}

	private fun setup(result: MethodChannel.Result) {
		if (resultConsumer != null) {
			resultConsumer?.throwError(Exception("New operation arrived before the current one finished"))
		}
		resultConsumer = ResultConsumer(result) { resultConsumer = null }
	}

	fun login(permissions: List<String>, result: MethodChannel.Result) {
		setup(result)

		val accessToken = AccessToken.getCurrentAccessToken()
		if (accessToken != null) {
			resultConsumer?.consume(resultFromAccessToken(accessToken))
			return
		}

		loginManager.logIn(activity, permissions)
	}

	fun logout(result: MethodChannel.Result) {
		setup(result)

		val hasPreviousSession = AccessToken.getCurrentAccessToken() != null
		if (hasPreviousSession) {
			loginManager.logOut()
		}

		resultConsumer?.consume(true)
	}
}