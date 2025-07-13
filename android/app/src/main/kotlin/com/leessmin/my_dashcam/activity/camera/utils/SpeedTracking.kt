package com.leessmin.my_dashcam.activity.camera.utils

import android.Manifest
import android.content.Context
import android.content.Context.LOCATION_SERVICE
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.os.HandlerThread
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner

private const val TAG = "SpeedTracking"

/**
 * 速度追踪
 *  @param context 上下文
 *  使用时必须先开启 [startService]
 */
class SpeedTracking(private val context: Context) {

    // 1. 准备后台线程
    private var thread: HandlerThread? = null

    private val locationManager =
        context.getSystemService(LOCATION_SERVICE) as LocationManager

    // 当前速度（单位km/h）
    @Volatile
    var currentSpeed: Float = 0f
        private set

    private val locationListener = object : LocationListener {
        override fun onLocationChanged(location: Location) {
            currentSpeed = location.speed * 3.6f
        }

        override fun onStatusChanged(p: String?, s: Int, e: Bundle?) {}
        override fun onProviderEnabled(p: String) {}
        override fun onProviderDisabled(p: String) {}
    }

    /**
     * 开启速度追踪服务
     * @throws SecurityException
     */
    fun startService() {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED
        ) {
            throw SecurityException("需要 ACCESS_FINE_LOCATION 权限")
        }

        if (thread != null) {
            Log.w(TAG, "速度追踪服务已启动，无法再次启动")
            return
        }
        thread = HandlerThread("${TAG}thread").apply { start() }

        // 更新速度间隔1秒，最小移动距离0m
        locationManager.requestLocationUpdates(
            LocationManager.GPS_PROVIDER, 1000L, 0f, locationListener, thread?.looper
        )
    }

    // 停止速度追踪服务
    fun stopService() {
        if (thread == null) {
            Log.w(TAG, "速度追踪服务未开启")
            return
        }
        locationManager.removeUpdates(locationListener)

        thread?.quitSafely()
        thread = null
    }
}