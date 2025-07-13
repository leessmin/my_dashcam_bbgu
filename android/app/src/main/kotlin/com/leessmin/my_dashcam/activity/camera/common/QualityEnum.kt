package com.leessmin.my_dashcam.activity.camera.common

import androidx.camera.video.Quality

/**
 * 视频质量枚举，通过这个枚举将 [String] 转 [androidx.camera.video.Quality]
 * @param key key值
 * @param value 视频质量
 */
enum class QualityEnum(val key: String, val value: Quality) {
    SD(key = "SD", value = Quality.SD),
    HD(key = "HD", value = Quality.HD),
    FHD(key = "FHD", value = Quality.FHD),
    UHD(key = "UHD", value = Quality.UHD),
    LOWEST(key = "LOWEST", value = Quality.LOWEST);

    companion object {
        /**
         * 通过 [String] 获得视频质量 [Quality]
         * @param key key值 [SD, HD, FHD, UHD, LOWEST]
         * @return [QualityEnum] 视频质量，如果找不到默认返回HD
         */
        fun fromKey(key: String):  QualityEnum = entries.find { it.key == key } ?: HD
    }
}