package com.leessmin.my_dashcam.activity.camera.data.controller

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Color
import android.graphics.PorterDuff
import android.graphics.SurfaceTexture
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Surface
import androidx.annotation.RequiresApi
import androidx.camera.core.CameraEffect
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.core.SurfaceRequest
import androidx.camera.core.UseCaseGroup
import androidx.camera.effects.OverlayEffect
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.lifecycle.awaitInstance
import androidx.camera.video.FileOutputOptions
import androidx.camera.video.Quality
import androidx.camera.video.QualitySelector
import androidx.camera.video.Recorder
import androidx.camera.video.Recording
import androidx.camera.video.VideoCapture
import androidx.camera.video.VideoRecordEvent
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.leessmin.my_dashcam.FlutterChannel
import com.leessmin.my_dashcam.activity.camera.common.FrameRate
import com.leessmin.my_dashcam.activity.camera.utils.DrawWatermark
import com.leessmin.my_dashcam.activity.camera.utils.SpeedTracking
import com.leessmin.my_dashcam.activity.camera.utils.fileClean
import com.leessmin.my_dashcam.activity.camera.utils.getNowTimeString
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.awaitCancellation
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.nio.file.Paths
import java.util.concurrent.Executors
import kotlin.io.path.pathString
import kotlin.math.floor

private const val TAG = "CameraController"

/**
 * 虚拟Surface
 * 用来欺骗camerax,当应用进入后台时，使用虚拟Surface欺骗camerax,不停止录制
 */
private class VirtualSurfaceProvider : Preview.SurfaceProvider {
    override fun onSurfaceRequested(request: SurfaceRequest) {
        val texture = SurfaceTexture(0)
        texture.setDefaultBufferSize(request.resolution.width, request.resolution.height)
        val surface = Surface(texture)

        request.provideSurface(surface, Executors.newSingleThreadExecutor()) {
            surface.release()
            texture.release()
        }
    }
}


/**
 * 摄像头控制器配置
 */
data class CameraControllerOptions(
    val quality: Quality = Quality.HD, // 分辨率, 默认720p
    val rotation: Int = Surface.ROTATION_90, // 旋转角度，默认90度
    val frameRate: FrameRate = FrameRate.FPS_30, // 录制视频的帧率，默认30FPS
    val recordSpeed: Boolean = true, // 是否记录车速， 默认启用
    val recordVoice: Boolean = true, // 是否记录声音，默认启用
    val stabilization: Boolean = true, // 是否启用防抖，默认启用
    val videoSavePath: String, // 视频保存路径
    val maxSaveSize: Int, // 最大存储空间 单位GB
)

/**
 * 摄像头控制器
 * @param options 控制器配置
 * @param speedTracking 速度追踪器
 *
 * @throws SecurityException
 */
class CameraController(
    private val options: CameraControllerOptions,
    private val speedTracking: SpeedTracking,
) {
    // 摄像头的生命周期
    private val cameraLifecycleOwner: CameraLifecycleOwner = CameraLifecycleOwner.getInstance()

    // 摄像头实例
    private var _processCameraProvider: ProcessCameraProvider? = null

    // 摄像头预览
    private val _cameraPreview = Preview.Builder().build()

    // 视频录制器
    private var _record: Recording? = null

    // 视频截取器
    private var _videoCapture: VideoCapture<Recorder> = createVideoCapture()

    // 绘制水印
    private val drawWatermark: DrawWatermark = DrawWatermark()

    // 水印层
    private val overlayEffect = OverlayEffect(
        CameraEffect.VIDEO_CAPTURE,
        0,
        Handler(Looper.getMainLooper())
    ) {
        Log.e(TAG, "overlayEffect error")
    }.apply {

        // 清除setOnDrawListener的监听
        clearOnDrawListener()

        // 在每一帧上绘制水印
        setOnDrawListener {
            // 保存当前 Canvas 状态
            it.overlayCanvas.save()
            it.overlayCanvas.drawColor(Color.TRANSPARENT, PorterDuff.Mode.CLEAR) // 清除上一帧
            it.overlayCanvas.setMatrix(it.sensorToBufferTransform)  // 应用传感器到缓冲区的转换矩阵 应用传感器

            val text = buildString {
                if (options.recordSpeed) {
                    append("当前车速: ${floor(speedTracking.currentSpeed).toInt()}Km/h | ")
                }
                append(getNowTimeString("yyyy-MM-dd HH:mm:ss"))
            }

            // 旋转角度options.rotation - 1之所以减1是因为默认绘画角度和视频方向相差一个90度
            drawWatermark.draw(it.overlayCanvas, text, options.rotation - 1)

            true
        }
    }

    init {
        // 启动获取速度服务
        if (options.recordSpeed) {
            speedTracking.startService()
        }
    }

    // 创建VideoCapture
    private fun createVideoCapture(): VideoCapture<Recorder> = VideoCapture.Builder(
        Recorder.Builder().setQualitySelector(QualitySelector.from(options.quality)).build()
    ).let {
        it.setVideoStabilizationEnabled(options.stabilization)
        it.setTargetFrameRate(options.frameRate.value)
        it.setTargetRotation(options.rotation)
        it.build()
    }

    // 录像集合
    private val useCaseGroup: UseCaseGroup
        get() = UseCaseGroup.Builder()
            .addEffect(overlayEffect)
            .addUseCase(_videoCapture)
            .addUseCase(_cameraPreview)
            .build()


    // 重新绑定相机实例
    private suspend fun reapplyBindToLifecycle() {
        // 绑定相机必须运行在主线程上
        withContext(Dispatchers.Main) {
            _videoCapture = createVideoCapture()

            // 重新应用到相机
            _processCameraProvider.apply {
                this!!.unbindAll()

                bindToLifecycle(
                    cameraLifecycleOwner,
                    CameraSelector.DEFAULT_BACK_CAMERA,
                    useCaseGroup,
                )
            }
        }

    }

    /**
     * 绑定摄像头
     * NOTE: 这段代码必须运行在主线程上
     */
    suspend fun bindToCamera(context: Context) {
        _processCameraProvider = ProcessCameraProvider.awaitInstance(context)
        _processCameraProvider?.bindToLifecycle(
            cameraLifecycleOwner,
            CameraSelector.DEFAULT_BACK_CAMERA,
            useCaseGroup,
        )

        // 完成释放摄像头资源
        try {
            awaitCancellation()
        } finally {
            Log.i(TAG, "摄像头资源释放")
            _processCameraProvider?.unbindAll()
        }
    }

    /**
     * 为摄像头添加预览
     * @param surfaceProvider 可为空，如果为空则使用虚拟Surface[VirtualSurfaceProvider]
     */
    fun setSurfaceProvider(surfaceProvider: Preview.SurfaceProvider?) {
        _cameraPreview.surfaceProvider = surfaceProvider ?: VirtualSurfaceProvider()
    }

    /**
     * 开始视频录制
     * @param context 上下文对象
     * @param dir 视频存储的上级目录路径
     * @throws SecurityException 当启用音频录制但未授予录音权限时抛出
     */
    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    fun startRecorder(context: Context, dir: String) {
        if (_record != null) {
            // _record不为空说明已经在录制了
            Log.w(TAG, "_record!=null，不能重复录制")
            return
        }

        val name = "${System.currentTimeMillis()}.mp4"

        /* 外部存储
        val contentValues = ContentValues().apply {
            put(MediaStore.Video.Media.DISPLAY_NAME, name)
        }
        val mediaStoreOutput = MediaStoreOutputOptions.Builder(
            context.contentResolver, MediaStore.Video.Media.EXTERNAL_CONTENT_URI
        ).setContentValues(contentValues).build()
        */

        val path = Paths.get(options.videoSavePath, dir).pathString
        // 内部存储
        val videoFile = File(path, name)
        Log.d(TAG, "视频录制路径: ${videoFile.path}")
        val fileOutputOptions = FileOutputOptions.Builder(videoFile).build()

        _record =
            _videoCapture.output.prepareRecording(context, fileOutputOptions).apply {
                if (options.recordVoice) {
                    // 判断权限
                    if (ActivityCompat.checkSelfPermission(
                            context,
                            Manifest.permission.RECORD_AUDIO
                        ) != PackageManager.PERMISSION_GRANTED
                    ) {
                        Log.e(TAG, "不存在录音权限")
                        throw SecurityException("不存在录音权限")
                    }
                    withAudioEnabled()
                }
            }.start(ContextCompat.getMainExecutor(context)) { videoRecordEvent ->
                when (videoRecordEvent) {
                    is VideoRecordEvent.Start -> {
                        // 开始录制
                    }

                    is VideoRecordEvent.Pause -> {
                        // 录制暂停
                    }

                    is VideoRecordEvent.Resume -> {
                        // 录制恢复
                    }

                    is VideoRecordEvent.Finalize -> {
                        // 录制完成
                        FlutterChannel.factory().recordedVideo(dir, videoFile.path)
                    }
                }
            }

        // 确保存储空间的足够，清理老旧视频
        CoroutineScope(Dispatchers.IO).launch {
            fileClean(options.videoSavePath, options.maxSaveSize) { path ->
                CoroutineScope(Dispatchers.Main).launch {
                    FlutterChannel.factory().deletedVideo(path);
                }
            }
        }
    }

    // 停止录像
    suspend fun stopRecorder() {
        if (_record == null) {
            Log.w(TAG, "_record==null, 录制未开启")
            return
        }

        Log.d(TAG, "录制又停止了")
        _record?.stop()

        _record = null

        // 重新绑定相机实例
        try {
            reapplyBindToLifecycle()
        } catch (e: Exception) {
            Log.e(TAG, e.message!!)
        }
    }

    // 销毁摄像头
    fun destroy() {
        speedTracking.stopService()
        instance = null
        cameraLifecycleOwner.destroy()
    }

    companion object {
        @Volatile
        private var instance: CameraController? = null

        /**
         * 初始化摄像头控制器
         * @param options 摄像头参数
         * @param context 上下文 使用当前上下文构建 SpeedTracking 速度追踪
         */
        fun initCameraController(
            options: CameraControllerOptions,
            context: Context
        ) {
            Log.d(TAG, "初始化摄像头, instance=${instance}")
            instance ?: synchronized(this) {
                instance ?: CameraController(options, SpeedTracking(context)).also { instance = it }
            }
        }

        /**
         * 单例模式
         * @throws IllegalStateException 没有初始化，就调用实例
         */
        fun getInstance(): CameraController {
            return instance
                ?: throw IllegalStateException("CameraController must be initialized first. Call initCameraController() before getInstance()")
        }
    }
}