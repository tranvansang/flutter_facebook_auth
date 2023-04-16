package me.transang.plugins.facebook_auth

import android.content.IntentSender.SendIntentException
import io.flutter.plugin.common.MethodChannel

class ResultConsumer<T>(
	private val result: MethodChannel.Result,
	private val onDone: () -> Unit
) {
	private var isDone = false
	fun throwError(e: Exception?) {
		if (isDone) throw Exception("ResultConsumer is already done")
		end()
		when (e) {
			is SendIntentException -> {
				result.error("FAIL_TO_SEND_INTENT", e.message, e)
			}
			null -> result.error(
				"NO_DATA",
				"No data provided",
				null
			)
			else -> result.error("OTHER", e.message, e)
		}
	}

	fun consume(value: T) {
		if (isDone) throw Exception("ResultConsumer is already done")
		end()
		result.success(value)
	}

	private fun end() {
		isDone = true
		onDone()
	}
}