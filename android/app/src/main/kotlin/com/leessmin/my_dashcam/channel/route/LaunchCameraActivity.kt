package com.leessmin.my_dashcam.channel.route

import android.content.Context
import android.content.Intent
import com.leessmin.my_dashcam.activity.camera.CameraActivity
import com.leessmin.my_dashcam.channel.ChannelRoute
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/// 启动CameraActivity
val LaunchCameraActivity: ChannelRoute =
    { context: Context, call: MethodCall, result: MethodChannel.Result ->

        val intent = Intent(context, CameraActivity::class.java).apply {
            putExtra("quality", call.argument<String>("quality"))
            putExtra("rotation", call.argument<Int>("rotation"))
            putExtra("frameRate", call.argument<Int>("frameRate"))
            putExtra("recordSpeed", call.argument<Boolean>("recordSpeed"))
            putExtra("recordVoice", call.argument<Boolean>("recordVoice"))
            putExtra("stabilization", call.argument<Boolean>("stabilization"))
            putExtra("interval", call.argument<Int>("interval"))
            putExtra("videoSavePath", call.argument<String>("videoSavePath"))
            putExtra("lockScreen", call.argument<Boolean>("lockScreen"))
            putExtra("maxSaveSize", call.argument<Int>("maxSaveSize"))
        }

        context.startActivity(intent)
    }