package com.leessmin.my_dashcam.activity.camera

import android.util.Log
import android.view.Surface
import androidx.activity.ComponentActivity
import com.leessmin.my_dashcam.activity.camera.common.FrameRate
import com.leessmin.my_dashcam.activity.camera.common.QualityEnum
import com.leessmin.my_dashcam.activity.camera.data.controller.CameraControllerOptions

/**
 * CameraActivity 配置
 */
data class CameraActivityOptions(
    // 视频质量
    val quality: QualityEnum,
    // 旋转角度, 0=>0度 1=>90度， 2=>180度 3=>270度
    val rotation: Int,
    // 视频帧率
    val frameRate: FrameRate,
    // 是否记录车速
    val recordSpeed: Boolean,
    // 是否记录声音
    val recordVoice: Boolean,
    // 是否启用防抖
    val stabilization: Boolean,
    // 分段录制间隔时间 [1,3,5,10], 单位分钟
    val interval: Int,
    // 录制存储的目录
    val videoSavePath: String,
    // 进入activity是否锁定屏幕
    val lockScreen: Boolean,
    // 最大存储空间 单位GB, 0 代表未开启
    val maxSaveSize: Int,
) {
    companion object {
        private const val TAG = "CameraActivityOptions"

        fun factory(activity: ComponentActivity): CameraActivityOptions {
            val extras = activity.intent.extras
            if (extras == null) {
                Log.e(TAG, "activity.intent.extras为空")
                return CameraActivityOptions(
                    quality = QualityEnum.HD,
                    rotation = Surface.ROTATION_90,
                    frameRate = FrameRate.FPS_30,
                    recordSpeed = true,
                    recordVoice = true,
                    stabilization = true,
                    interval = 3,
                    videoSavePath = "${activity.filesDir}/video",
                    lockScreen = true,
                    maxSaveSize = 0,
                )
            }

            return CameraActivityOptions(
                quality = QualityEnum.fromKey(extras.getString("quality", "HD")),
                rotation = extras.getInt("rotation", Surface.ROTATION_90),
                frameRate = FrameRate.fromFps(extras.getInt("frameRate", 30)),
                recordSpeed = extras.getBoolean("recordSpeed", true),
                recordVoice = extras.getBoolean("recordVoice", true),
                stabilization = extras.getBoolean("stabilization", true),
                interval = extras.getInt("interval", 3),
                videoSavePath = extras.getString("videoSavePath", "${activity.filesDir}/video"),
                lockScreen = extras.getBoolean("lockScreen", true),
                maxSaveSize = extras.getInt("maxSaveSize", 0)
            )
        }
    }

    fun toCameraControllerOptions(): CameraControllerOptions {
        return CameraControllerOptions(
            quality = quality.value,
            rotation = rotation,
            frameRate = frameRate,
            recordSpeed = recordSpeed,
            recordVoice = recordVoice,
            stabilization = stabilization,
            videoSavePath = videoSavePath,
            maxSaveSize = maxSaveSize
        )
    }
}

