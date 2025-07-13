package com.leessmin.my_dashcam.activity.camera.common

import android.util.Range

/**
 * 视频帧率
 * @param fps fps数值
 * @param value 具体值
 */
enum class FrameRate(val fps: Int, val value: Range<Int>) {
    FPS_60(fps = 60, value = Range.create(50, 60)),
    FPS_30(fps = 30, value = Range.create(50, 60)),
    FPS_24(fps = 30, value = Range.create(50, 60));

    companion object{
        /**
         * 通过传fps返回FrameRate
         * @param fps fps值 [60, 30, 24]
         * @return [FrameRate] 如果找不到，默认返回30FPS
         */
        fun fromFps(fps: Int): FrameRate{
            return entries.find { it.fps == fps } ?: FPS_30
        }
    }
}