package com.leessmin.my_dashcam.activity.camera.data.repository

import android.content.Context
import android.content.Intent
import androidx.camera.core.Preview
import androidx.work.WorkManager
import com.leessmin.my_dashcam.activity.camera.data.controller.CameraController
import com.leessmin.my_dashcam.activity.camera.service.CameraService


/**
 * Camera 预览
 */
class CameraPreviewRepository(private val context: Context) {

    private val cameraController: CameraController
        get() = CameraController.getInstance()

    // 为摄像头添加预览
    fun setSurfaceProvider(surfaceProvider: Preview.SurfaceProvider) {
        cameraController.setSurfaceProvider(surfaceProvider)
    }

    // 为摄像头使用虚拟预览
    fun setVirtualSurfaceProvider() {
        cameraController.setSurfaceProvider(null)
    }

    // 绑定摄像头
    fun startCameraBindService() {
        val intent = Intent(context, CameraService::class.java)
        context.startService(intent)
    }

    // 停止摄像头绑定服务
    fun stopCameraBindService() {
        val intent = Intent(context, CameraService::class.java)
        context.stopService(intent)
    }

    companion object {
        const val WORK_NAME = "camera_worker"
    }
}