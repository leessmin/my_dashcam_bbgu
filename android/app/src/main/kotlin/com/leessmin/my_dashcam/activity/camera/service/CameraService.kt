package com.leessmin.my_dashcam.activity.camera.service

import android.app.Notification
import android.app.Service
import android.content.Intent
import android.os.IBinder
import com.leessmin.my_dashcam.activity.camera.data.controller.CameraController
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class CameraService : Service() {

    private val cameraController = CameraController.getInstance()

    companion object {
        const val NOTIFICATION_ID = 1
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = createNotification()
        startForeground(NOTIFICATION_ID, notification)

        CoroutineScope(Dispatchers.Main).launch {
            cameraController.bindToCamera(this@CameraService)
        }

        return START_STICKY
    }

    private fun createNotification(): Notification {
        return CameraServiceNotification.createNotification(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        // 关闭服务释放摄像头资源
        cameraController.destroy()
    }
}