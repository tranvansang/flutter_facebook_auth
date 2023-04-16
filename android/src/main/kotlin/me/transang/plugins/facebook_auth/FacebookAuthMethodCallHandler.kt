package me.transang.plugins.facebook_auth

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FacebookAuthMethodCallHandler(private val delegate: FacebookAuthDelegate) :
	MethodChannel.MethodCallHandler {
	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		when (call.method) {
			"login" -> {
				val permissions: List<String>? = call.argument("permissions")

				if (permissions == null) result.error(
					"Error initializing sign in",
					"permissions is required",
					null
				)
				else delegate.login(permissions, result)
			}

			"logout" -> delegate.logout(result)
			else -> result.notImplemented()
		}
	}
}
