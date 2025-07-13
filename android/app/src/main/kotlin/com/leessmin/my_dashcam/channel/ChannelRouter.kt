package com.leessmin.my_dashcam.channel

import android.content.Context
import com.leessmin.my_dashcam.channel.route.LaunchCameraActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/// channel 路由类型
typealias ChannelRoute = (Context, MethodCall, MethodChannel.Result) -> Unit

/// channel 路由
val ChannelRouter = hashMapOf<String, ChannelRoute>(
    "launchCameraActivity" to LaunchCameraActivity,
)