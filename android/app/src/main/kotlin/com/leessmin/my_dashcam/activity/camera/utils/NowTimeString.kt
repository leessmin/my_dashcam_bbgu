package com.leessmin.my_dashcam.activity.camera.utils

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

/**
 * 获取当前时间字符串
 * @param pattern 时间格式，默认 yyyy-MM-dd_HH:mm:ss
 * */
fun getNowTimeString(pattern: String = "yyyy-MM-dd_HH:mm:ss"): String {
    val now = LocalDateTime.now()
    val formatter = DateTimeFormatter.ofPattern(pattern)
    return now.format(formatter)
}