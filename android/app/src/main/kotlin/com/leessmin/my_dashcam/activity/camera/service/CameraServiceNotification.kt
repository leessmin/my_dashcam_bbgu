package com.leessmin.my_dashcam.activity.camera.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import androidx.core.app.NotificationCompat

class CameraServiceNotification {
    companion object {
        private const val CHANNEL_ID = "camera_service_notification"


        fun createNotification(context: Context): Notification {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "行车记录仪运行中",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "正在运行..."
            }
            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)

            return NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_menu_camera)
                .setContentTitle("行车记录仪")
                .setContentText("正在运行...")
                .setPriority(NotificationCompat.PRIORITY_MIN)
                .setVisibility(NotificationCompat.VISIBILITY_PRIVATE)
                .build()
        }
    }
}