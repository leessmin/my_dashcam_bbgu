package com.leessmin.my_dashcam

import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

// 调用flutter平台通道

class FlutterChannel(engine: FlutterEngine) {
    companion object {
        private const val CHANNEL = "com.leessmin.my_dashcam/flutter_channel"

        fun factory(): FlutterChannel {
            val engine = FlutterEngineCache.getInstance().get("flutter_channel")!!
            return FlutterChannel(engine)
        }
    }

    private val channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)

    // 上传视频
    fun recordedVideo(dirName: String, videoPath: String) {
        channel.invokeMethod("recordedVideo", listOf(dirName, videoPath))
    }
}