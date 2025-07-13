package com.leessmin.my_dashcam.activity.camera.ui

import android.app.Application
import androidx.camera.core.SurfaceRequest
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.leessmin.my_dashcam.activity.camera.data.repository.BatteryRepository
import com.leessmin.my_dashcam.activity.camera.data.repository.CameraPreviewRepository
import com.leessmin.my_dashcam.activity.camera.data.repository.RecordRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update

data class CameraScreenState(
    val surfaceRequest: SurfaceRequest? = null, // 画面
    val isRecorder: Boolean = false, // 是否开始录制
    val startRecorderTime: Long = 0L, // 开始录制的时间 时间戳
    val batteryLevel: Int = 0, // 电池电量
    val isCharging: Boolean = false, // 是否在充电
)

/**
 * CameraScreenViewModel
 * @param interval 录制分段时长
 * @param application 应用
 */
class CameraScreenViewModel(
    private val cameraRepository: CameraPreviewRepository,
    private val recordRepository: RecordRepository,
    private val batteryRepository: BatteryRepository,
    private val interval: Int,
    application: Application
) : AndroidViewModel(application) {

    private val _cameraScreenState = MutableStateFlow(CameraScreenState())
    val cameraScreenState: StateFlow<CameraScreenState> = _cameraScreenState.asStateFlow()

    init {
        batteryRepository.onChange { level, isCharging ->
            _cameraScreenState.update {
                it.copy(
                    batteryLevel = level,
                    isCharging = isCharging
                )
            }
        }
        recordRepository.onStopListener {
            stopRecorder()
        }

        cameraRepository.startCameraBindService()

    }

    override fun onCleared() {
        super.onCleared()
        // 如果录像存在停止录像
        stopRecorder()
        // 销毁摄像头服务
        cameraRepository.stopCameraBindService()
    }

    fun setPreview() {
        cameraRepository.setSurfaceProvider { newSurfaceProvider ->
            _cameraScreenState.update {
                it.copy(
                    surfaceRequest = newSurfaceProvider
                )
            }
        }
    }

    fun setVirtualPreview() {
        cameraRepository.setVirtualSurfaceProvider()
    }

    // 开始录制
    fun startRecorder() {
        if (cameraScreenState.value.isRecorder) {
            return
        }

        recordRepository.startRecorder(interval)

        _cameraScreenState.update {
            it.copy(
                isRecorder = true,
                startRecorderTime = System.currentTimeMillis()
            )
        }
    }

    // 停止录制
    fun stopRecorder() {
        if (!cameraScreenState.value.isRecorder) {
            return
        }

        recordRepository.stopRecording()

        _cameraScreenState.update {
            it.copy(
                isRecorder = false,
                startRecorderTime = System.currentTimeMillis(),
            )
        }
    }

    companion object {
        /**
         * 工厂函数
         * @param interval 录制间隔时间
         * @param application application应用程序
         */
        fun Factory(
            interval: Int,
            application: Application
        ): ViewModelProvider.Factory {
            return object : ViewModelProvider.Factory {
                @Suppress("UNCHECKED_CAST")
                override fun <T : ViewModel> create(modelClass: Class<T>): T {
                    if (modelClass.isAssignableFrom(CameraScreenViewModel::class.java)) {
                        return CameraScreenViewModel(
                            cameraRepository = CameraPreviewRepository(application),
                            recordRepository = RecordRepository(application),
                            batteryRepository = BatteryRepository(application),
                            interval = interval,
                            application = application,
                        ) as T
                    }
                    throw IllegalArgumentException("Unknown ViewModel class")
                }
            }
        }
    }
}