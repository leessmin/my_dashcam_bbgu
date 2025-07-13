package com.leessmin.my_dashcam

import android.content.Context
import android.util.Log
import com.leessmin.my_dashcam.channel.ChannelRouter
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val TAG = "ChannelMatch"
private const val CHANNEL = "com.leessmin.my_dashcam"

/// flutter channel 匹配
class ChannelMatch(
    private val context: Context
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        ChannelRouter[call.method]?.invoke(context, call, result) ?: run {
            Log.w(TAG, "The invoked method ${call.method} does not exits")
        }
        result.success("call success!!!")
    }

    companion object {
        fun build(context: Context, binaryMessenger: BinaryMessenger) {
            MethodChannel(
                binaryMessenger,
                CHANNEL
            ).setMethodCallHandler(ChannelMatch(context))
        }
    }

}