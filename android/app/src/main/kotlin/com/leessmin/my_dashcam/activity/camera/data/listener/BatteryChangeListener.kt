package com.leessmin.my_dashcam.activity.camera.data.listener

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager

/**
 * 电池监听变化回调,
 * level 电池电量
 * isCharging 是否处于充电中
 */
typealias OnBatteryChange = (level: Int, isCharging: Boolean) -> Unit

/**
 * 电池电量监听控制器
 */
class BatteryChangeListener(
    context: Context,
    private val onChange: OnBatteryChange
) {

    private val batteryReceiver = object : BroadcastReceiver() {
        override fun onReceive(
            context: Context?,
            intent: Intent?
        ) {
            intent?.let {
                val level = it.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                val scale = it.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                val status = it.getIntExtra(BatteryManager.EXTRA_STATUS, -1)

                val levelFormat = if (level >= 0 && scale > 0) {
                    (level * 100 / scale.toInt()).toInt()
                } else {
                    0
                }
                val charging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                        status == BatteryManager.BATTERY_STATUS_FULL

                onChange(levelFormat, charging)
            }
        }
    }

    init {
        val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        context.registerReceiver(batteryReceiver, filter)
    }
}