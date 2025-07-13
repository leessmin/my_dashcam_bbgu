package com.leessmin.my_dashcam.activity.camera.ui

import android.Manifest
import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.activity.compose.BackHandler
import androidx.camera.compose.CameraXViewfinder
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.KeyboardReturn
import androidx.compose.material.icons.filled.BatteryChargingFull
import androidx.compose.material.icons.filled.BatteryStd
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.google.accompanist.permissions.isGranted
import com.google.accompanist.permissions.rememberPermissionState
import com.leessmin.my_dashcam.R
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import com.leessmin.my_dashcam.activity.camera.utils.getDurationString
import kotlinx.coroutines.delay

/**
 * 相机屏幕
 * 需要 [Manifest.permission.CAMERA] 权限
 * @param onFinish 退出当前 Activity 方法
 */
@OptIn(ExperimentalPermissionsApi::class)
@Composable
fun CameraScreen(
    modifier: Modifier = Modifier,
    viewModel: CameraScreenViewModel,
    lifecycleOwner: LifecycleOwner = LocalLifecycleOwner.current,
    context: Context = LocalContext.current,
    onFinish: () -> Unit,
) {
    val cameraPermissionState = rememberPermissionState(Manifest.permission.CAMERA)

    val cameraScreenState by viewModel.cameraScreenState.collectAsStateWithLifecycle()

    DisposableEffect(lifecycleOwner) {
        // 页面生命周期监听
        val observer = LifecycleEventObserver { _, event ->
            when (event) {
                Lifecycle.Event.ON_STOP -> {
                    // 用户切换后台 设置虚拟预览，欺骗camerax
                    Log.i("CameraScreen", "用户切换后台")
                    viewModel.setVirtualPreview()
                }

                Lifecycle.Event.ON_RESUME -> {
                    // app回到前台 设置预览
                    viewModel.setPreview()
                }

                Lifecycle.Event.ON_START -> {
                    // 生命周期开始，设置预览
                    viewModel.setPreview()
                }

                else -> Unit
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)

        onDispose {
            Log.i("CameraScreen", "Screen销毁...")
            lifecycleOwner.lifecycle.removeObserver(observer)
        }
    }


    val cannotBackToast = {
        Toast.makeText(context, "录制中, 不能退出", Toast.LENGTH_SHORT).show()
    }

    BackHandler(enabled = cameraScreenState.isRecorder) {
        cannotBackToast()
    }


    Surface(modifier = modifier.fillMaxSize()) {
        if (cameraPermissionState.status.isGranted) {
            CameraPreviewContent(
                cameraScreenState = cameraScreenState, onRecord = {
                    viewModel.startRecorder()
                }, onStop = {
                    viewModel.stopRecorder()
                }, onFinish = {
                    if (cameraScreenState.isRecorder) {
                        cannotBackToast()
                        return@CameraPreviewContent
                    }
                    onFinish()
                }
            )
        } else {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Image(
                    painter = painterResource(R.drawable.no_permission),
                    contentDescription = "没有权限"
                )
                Text(" \uD83D\uDC2C 需要相机(CAMERA)权限! \uD83D\uDC2C")
                Spacer(modifier = Modifier.height(24.dp))
                Button(
                    onClick = {
                        cameraPermissionState.launchPermissionRequest()
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xffca9ee6)),
                ) {
                    Text("请求权限")
                }
            }
        }
    }
}


/**
 * 摄像机预览内容
 */
@Composable
fun CameraPreviewContent(
    modifier: Modifier = Modifier,
    cameraScreenState: CameraScreenState,
    onRecord: () -> Unit,
    onStop: () -> Unit,
    onFinish: () -> Unit
) {
    Box(modifier) {
        cameraScreenState.surfaceRequest?.let { request ->
            CameraXViewfinder(
                surfaceRequest = request,
            )
        }
        CameraStatusTopBar(
            modifier = Modifier
                .align(Alignment.TopStart)
                .statusBarsPadding(),
            state = cameraScreenState
        )
        Row(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .padding(bottom = 16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            CameraRecordButton(
                isRecorder = cameraScreenState.isRecorder, onRecord = onRecord, onStop = onStop
            )
        }
        Row(
            modifier = Modifier
                .align(Alignment.BottomStart)
                .padding(bottom = 16.dp, start = 20.dp)
        ) {
            IconButton(
                enabled = !cameraScreenState.isRecorder,
                onClick = onFinish,
                modifier = Modifier
                    .clip(CircleShape)
                    .background(Color(0xffca9ee6))
            ) {
                Icon(
                    imageVector = Icons.AutoMirrored.Outlined.KeyboardReturn,
                    contentDescription = null
                )
            }
        }
    }
}

// 录制按钮
@Composable
fun CameraRecordButton(
    modifier: Modifier = Modifier,
    isRecorder: Boolean,
    onRecord: () -> Unit,
    onStop: () -> Unit,
) {
    // 录制视频圆形按钮的动画
    val animatedRadius by animateFloatAsState(
        targetValue = if (isRecorder) 0.2f else 0.5f,
        animationSpec = tween(durationMillis = 300),
    )

    val openConfirmStopDialog = remember { mutableStateOf(false) }

    Box(
        modifier = modifier
            .size(80.dp)
            .clip(CircleShape)
            .background(Color.White)
            .clickable(
                onClick = {
                    if (isRecorder) {
                        openConfirmStopDialog.value = true
                    } else {
                        onRecord()
                    }
                })
    ) {
        Box(
            modifier = Modifier
                .size(38.dp)
                .clip(RoundedCornerShape(percent = (animatedRadius * 100).toInt()))
                .background(Color(0xfff4b8e4))
                .align(Alignment.Center)
        )
    }

    ConfirmStopDialog(
        open = openConfirmStopDialog.value,
        onDismiss = { openConfirmStopDialog.value = false },
        onConfirm = {
            openConfirmStopDialog.value = false
            onStop()
        }
    )
}

// 确认停止录制弹窗
@Composable
fun ConfirmStopDialog(
    modifier: Modifier = Modifier,
    open: Boolean,
    onDismiss: () -> Unit,
    onConfirm: () -> Unit
) {
    when {
        open -> {
            AlertDialog(
                modifier = modifier,
                title = { Text(text = "停止录制") },
                text = { Text(text = "你确定要停止录制吗") },
                onDismissRequest = onDismiss,
                confirmButton = {
                    TextButton(onClick = onConfirm) {
                        Text("停止")
                    }
                },
                dismissButton = {
                    TextButton(onClick = onDismiss) {
                        Text("取消")
                    }
                }
            )
        }
    }
}

// 顶部状态栏
@Composable
fun CameraStatusTopBar(
    modifier: Modifier = Modifier,
    state: CameraScreenState,
) {
    // 录制红点动画
    val infiniteTransition = rememberInfiniteTransition(label = "blinking")
    val animatedAlpha by infiniteTransition.animateFloat(
        initialValue = 0f, targetValue = 1f, animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 1000, easing = LinearEasing, delayMillis = 200),
            repeatMode = RepeatMode.Reverse
        ), label = "alpha"
    )
    val blinkingAlpha = if (state.isRecorder) animatedAlpha else 0f

    // 已经录制的时长
    var recordDuration by remember { mutableStateOf("") }

    LaunchedEffect(state.isRecorder) {
        if (state.isRecorder) {
            while (true) {
                recordDuration = getDurationString(state.startRecorderTime)
                delay(1000L)
            }
        } else {
            recordDuration = "00:00:00"
        }
    }

    Row(
        modifier = modifier
            .fillMaxWidth()
            .background(Color(0x80FFFFFF))
            .padding(vertical = 2.dp, horizontal = 20.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(
                imageVector = if (state.isCharging) Icons.Default.BatteryChargingFull else Icons.Default.BatteryStd,
                contentDescription = null
            )
            Text("${state.batteryLevel}%")
        }
        Text(text = recordDuration)
        Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
                modifier
                    .width(15.dp)
                    .height(15.dp)
                    .clip(CircleShape)
                    .alpha(blinkingAlpha)
                    .background(Color.Red)
            )
        }
    }
}