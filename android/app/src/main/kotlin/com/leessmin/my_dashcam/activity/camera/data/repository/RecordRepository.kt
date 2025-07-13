package com.leessmin.my_dashcam.activity.camera.data.repository

import android.content.Context
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import androidx.work.workDataOf
import com.leessmin.my_dashcam.activity.camera.data.listener.RecordStopListener
import com.leessmin.my_dashcam.activity.camera.workers.RecordWorker

/**
 * camera 录制
 * 这个repository 会启动WorkerManager进行录制
 * 具体Worker [RecordWorker]
 */
class RecordRepository(context: Context) {

    private val workerManager = WorkManager.getInstance(context)

    /**
     * 启动录制任务
     * @param interval 分段录制的时长,
     */
    fun startRecorder(interval: Int) {
        // 停止已有录制任务避免重复
        stopRecording()

        val request =
            OneTimeWorkRequestBuilder<RecordWorker>().setInputData(
                workDataOf("interval" to interval)
            ).setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                .addTag(WORK_TAG).build()
        workerManager.enqueue(request)
    }

    /**
     * 停止录制任务
     */
    fun stopRecording() {
        workerManager.cancelAllWorkByTag(WORK_TAG)
    }

    /**
     * 监听是否触发停止
     */
    fun onStopListener(onStop: () -> Unit) {
        RecordStopListener.stopRecordEvent.observeForever {
            onStop()
        }
    }

    companion object {
        const val WORK_TAG = "record_worker"
    }
}