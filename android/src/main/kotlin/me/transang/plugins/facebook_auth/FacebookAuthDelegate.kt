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
) : ResultConsumer() {
	private val loginManager = LoginManager.getInstance()

	companion object {
		const val ERR_USER_CANCELLED = "USER_CANCELLED"
		const val ERR_OPERATION_FAIL = "OPERATION_FAIL"
	}

	init {
		loginManager.registerCallback(callbackManager, object : FacebookCallback<LoginResult> {
			override fun onCancel() {
				throwError(ERR_USER_CANCELLED, "User cancelled", null)
			}

			override fun onError(error: FacebookException) {
				throwError(ERR_OPERATION_FAIL, error.message, error)
			}

			override fun onSuccess(result: LoginResult) {
				returnResult(resultFromAccessToken(result.accessToken))
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
		ret["grantedPermissions"] = accessToken.permissions.toMutableList()
		ret["declinedPermissions"] = accessToken.declinedPermissions.toMutableList()
		ret["dataAccessExpirationTime"] = accessToken.dataAccessExpirationTime.time

		return ret
	}

	fun login(permissions: List<String>, result: MethodChannel.Result) {
		if (!setup(result)) return

		val accessToken = AccessToken.getCurrentAccessToken()
		if (accessToken != null) {
			returnResult(resultFromAccessToken(accessToken))
			return
		}

		loginManager.logIn(activity, permissions)
	}

	fun logout(result: MethodChannel.Result) {
		if (!setup(result)) return

		val hasPreviousSession = AccessToken.getCurrentAccessToken() != null
		if (hasPreviousSession) {
			loginManager.logOut()
		}

		returnResult(true)
	}
}
