package com.leessmin.my_dashcam.activity.camera.broadcast

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.leessmin.my_dashcam.activity.camera.data.listener.RecordStopListener

/**
 * 广播action
 */
enum class ActionReceiverAction() {
    // 停止录制 camera
    CAMERA_STOP_RECORD,
}

/**
 * 广播
 */
class ActionBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        when (intent?.action) {
            ActionReceiverAction.CAMERA_STOP_RECORD.name -> {
                RecordStopListener.sendStopRecord()
            }
        }

    }
}