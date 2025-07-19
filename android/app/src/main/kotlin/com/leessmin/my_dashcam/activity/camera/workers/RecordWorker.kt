package com.leessmin.my_dashcam.activity.camera.workers

import android.content.Context
import android.content.pm.ServiceInfo
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.work.CoroutineWorker
import androidx.work.ForegroundInfo
import androidx.work.WorkerParameters
import com.leessmin.my_dashcam.activity.camera.data.controller.CameraController
import com.leessmin.my_dashcam.activity.camera.utils.GPSUtils
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import kotlin.time.Duration.Companion.minutes

private const val TAG = "RecordWorker"

class RecordWorker(
    private val appContext: Context,
    workerParams: WorkerParameters,
) :
    CoroutineWorker(appContext, workerParams) {

    private val cameraController: CameraController
        get() = CameraController.getInstance()

    @RequiresApi(Build.VERSION_CODES.R)
    override suspend fun getForegroundInfo(): ForegroundInfo {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            ForegroundInfo(
                NOTIFICATION_ID,
                RecordWorkerNotification.createNotification(appContext),
                ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA or ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE or ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
            )
        } else {
            ForegroundInfo(NOTIFICATION_ID, RecordWorkerNotification.createNotification(appContext))
        }
    }

    /**
     * 启动工作
     * [getInputData] => interval of [Int] 录制间隔时间 默认为3,单位minutes
     */
    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val interval = inputData.getInt("interval", 3)

        setForeground(getForegroundInfo())

        // 开始录制的时间
        val nowRecord = System.currentTimeMillis().toString()
        // TODO: 记录GPS位置

        // 记录gps数据
        val gpsUtils = GPSUtils("$nowRecord.txt", applicationContext)
        gpsUtils.startLocation()
        try {
            while (true) {
                Log.i(TAG, "循环录制了!")
                cameraController.startRecorder(applicationContext, nowRecord)
                delay(interval.minutes)
                cameraController.stopRecorder()
            }
        } catch (_: CancellationException) {
            cameraController.stopRecorder()
            Log.i(TAG, "录制被取消")
        } catch (e: Exception) {
            Log.e(TAG, "录制失败: ${e.message}", e)
            cameraController.stopRecorder()
            Result.failure()
        } finally {
            Log.i(TAG, "录制完成!!!!!!!")
            gpsUtils.stopLocation()
        }
        Result.success()
    }


    companion object {
        private const val NOTIFICATION_ID = 1001
    }
}
