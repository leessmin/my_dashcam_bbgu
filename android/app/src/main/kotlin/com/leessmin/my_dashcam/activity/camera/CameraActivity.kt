package com.leessmin.my_dashcam.activity.camera

import android.content.pm.ActivityInfo
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.Surface
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.annotation.RequiresApi
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.lifecycle.viewmodel.compose.viewModel
import com.leessmin.my_dashcam.activity.camera.data.controller.CameraController
import com.leessmin.my_dashcam.activity.camera.ui.CameraScreen
import com.leessmin.my_dashcam.activity.camera.ui.CameraScreenViewModel


class CameraActivity : ComponentActivity() {

    companion object {
        private const val TAG = "CameraActivity"
    }

    // activity配置
    lateinit var options: CameraActivityOptions

    /**
     * 初始化
     */
    fun initialization() {
        options = CameraActivityOptions.factory(this)
        Log.d(TAG, "Activity option: $options")

        // 初始化摄像头
        CameraController.initCameraController(
            options = options.toCameraControllerOptions(),
            context = this
        )

        if (options.lockScreen) {
            startLockTask()
        }

        when (options.rotation) {
            Surface.ROTATION_90 -> requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
            Surface.ROTATION_270 -> requestedOrientation =
                ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE
        }
    }

    @RequiresApi(Build.VERSION_CODES.O_MR1)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        initialization()

        enableEdgeToEdge()
        WindowInsetsControllerCompat(window, window.decorView).let { controller ->
            // 隐藏状态栏
            controller.hide(WindowInsetsCompat.Type.statusBars())
            // 设置状态栏自动隐藏
            controller.systemBarsBehavior =
                WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE
        }

        setContent {
            CameraScreen(
                viewModel = viewModel(
                    factory = CameraScreenViewModel.Factory(
                        interval = options.interval, // 录制间隔时间
                        application = application,
                    )
                ),
                onFinish = { finish() },
            )
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (options.lockScreen) {
            stopLockTask()
        }
    }
}