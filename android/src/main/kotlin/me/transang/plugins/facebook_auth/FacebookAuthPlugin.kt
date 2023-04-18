package me.transang.plugins.facebook_auth

import com.facebook.CallbackManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import me.transang.plugins.facebook_auth.FacebookAuthDelegate.Companion.ERR_OTHER
import me.transang.plugins.facebook_auth.FacebookAuthDelegate.Companion.ERR_PARAM_REQUIRED

class FacebookAuthPlugin : FlutterPlugin, ActivityAware {
	private var detachFromEngine: (() -> Unit)? = null
	private var detachFromActivity: (() -> Unit)? = null
	private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null

	// BEGIN attach to engine
	override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
		flutterPluginBinding = binding
		detachFromEngine = {
			detachFromEngine = null
			flutterPluginBinding = null
		}
	}

	override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
		detachFromEngine?.invoke()
	}
	// END attach to engine

	// BEGIN attach to activity
	override fun onAttachedToActivity(binding: ActivityPluginBinding) {
		val pluginBinding = flutterPluginBinding!!
		val methodChannel = MethodChannel(
			pluginBinding.binaryMessenger,
			"me.transang.plugins.facebook_auth/channel"
		)
		val callbackManager = CallbackManager.Factory.create()
		val delegate = FacebookAuthDelegate(binding.activity, callbackManager)
		methodChannel.setMethodCallHandler { call, result ->
			try {
				when (call.method) {
					"login" -> {
						val permissions: List<String>? = call.argument("permissions")

						if (permissions == null) result.error(
							ERR_PARAM_REQUIRED,
							"permissions is required",
							null
						)
						else delegate.login(permissions, result)
					}

					"logout" -> delegate.logout(result)
					else -> result.notImplemented()
				}
			} catch (e: Exception) {
				result.error(ERR_OTHER, e.message, e)
			}
		}

		val activityResultListener =
			PluginRegistry.ActivityResultListener { requestCode, resultCode, data ->
				callbackManager.onActivityResult(
					requestCode,
					resultCode,
					data
				)
			}
		binding.addActivityResultListener(activityResultListener)

		detachFromActivity = {
			detachFromActivity = null
			binding.removeActivityResultListener(activityResultListener)
			methodChannel.setMethodCallHandler(null)
		}
	}

	override fun onDetachedFromActivity() {
		detachFromActivity?.invoke()
	}
	// END attach to activity

	// BEGIN temporary detach from activity
	override fun onDetachedFromActivityForConfigChanges() {
		detachFromActivity?.invoke()
	}

	override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
		onAttachedToActivity(binding)
	}
	// END temporary detach from activity
}
