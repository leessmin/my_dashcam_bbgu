package com.leessmin.my_dashcam.activity.camera.utils

import java.util.Locale

/**
 * 传入一个时间搓，计算当前时间和传入的时间戳的差
 * @param startMillis 传入的时间戳
 * @return [String] 返回格式 00:00:00
 */
fun getDurationString(startMillis: Long): String {
    val nowMillis = System.currentTimeMillis()
    val durationMillis = nowMillis - startMillis

    val totalSeconds = durationMillis / 1000
    val hours = totalSeconds / 3600
    val minutes = (totalSeconds % 3600) / 60
    val seconds = totalSeconds % 60

    return String.format(Locale.US, "%02d:%02d:%02d", hours, minutes, seconds)
}