package me.transang.plugins.facebook_auth

import android.content.Intent
import com.facebook.CallbackManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

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
		methodChannel.setMethodCallHandler(FacebookAuthMethodCallHandler(delegate))

		val onActivityResultListener =
			PluginRegistry.ActivityResultListener { requestCode, resultCode, data ->
				callbackManager.onActivityResult(
					requestCode,
					resultCode,
					data
				)
			}
		binding.addActivityResultListener(onActivityResultListener)

		detachFromActivity = {
			detachFromActivity = null
			binding.removeActivityResultListener(onActivityResultListener)
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
