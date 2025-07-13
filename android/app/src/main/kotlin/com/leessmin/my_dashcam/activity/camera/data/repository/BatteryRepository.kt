package com.leessmin.my_dashcam.activity.camera.data.repository

import android.content.Context
import com.leessmin.my_dashcam.activity.camera.data.listener.BatteryChangeListener
import com.leessmin.my_dashcam.activity.camera.data.listener.OnBatteryChange

/**
 * 电池
 */
class BatteryRepository(private val context: Context) {

    /**
     * 监听电池变化
     */
    fun onChange(handle: OnBatteryChange) {
        BatteryChangeListener(context, handle)
    }

}