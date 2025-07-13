package com.leessmin.my_dashcam.activity.camera.workers

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import com.leessmin.my_dashcam.R
import com.leessmin.my_dashcam.activity.camera.broadcast.ActionBroadcastReceiver
import com.leessmin.my_dashcam.activity.camera.broadcast.ActionReceiverAction


class RecordWorkerNotification {
    companion object {
        private const val CHANNEL_ID = "record_worker_notification"


        fun createNotification(context: Context): Notification {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "行车记录仪录制中",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "正在录制视频"
            }
            val notificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)

            val intent = Intent(context, ActionBroadcastReceiver::class.java).apply {
                action = ActionReceiverAction.CAMERA_STOP_RECORD.name
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context, 1, intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            return NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_menu_camera)
                .setContentTitle("行车记录仪")
                .setContentText("正在录制中...")
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setVisibility(NotificationCompat.VISIBILITY_PRIVATE)
                .addAction(R.drawable.stop, "停止录像", pendingIntent)
                .setOngoing(true)
                .setAutoCancel(true)
                .build()
        }
    }
}