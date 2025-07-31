package com.leessmin.my_dashcam.activity.camera.utils

import android.content.Context
import android.location.LocationManager
import android.os.Looper
import android.util.Log
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import java.io.File
import java.io.FileWriter
import java.io.IOException

/**
 * GPS工具
 * @param fileName 需要存储的文件名
 * @param context app context
 */
class GPSUtils(private val fileName: String, private val context: Context) {

    companion object {
        private const val TAG = "GPSUtils"
    }

    // 地理服务请求, 最小更新时间2秒
    private val locationRequest: LocationRequest =
        LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 10000)
            .setMinUpdateIntervalMillis(2000).build()

    private val fusedLocationClient: FusedLocationProviderClient by lazy {
        LocationServices.getFusedLocationProviderClient(context)
    }

    private var locationCallback: LocationCallback? = null

    /// 往文件追加数据
    private fun appendToFile(content: String) {
        try {
            // 如果文件不存在，父目录不存在会创建父目录
            FileWriter(
                createLocationFile(context, fileName),
                true
            ).use { writer ->
                writer.append("$content\n")
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    // 创建文件夹
    private fun createLocationFile(context: Context, fileName: String): File {
        // 1. 创建父目录（如果不存在）
        val parentDir = File("${context.filesDir.absolutePath}/location").apply {
            if (!exists()) {
                mkdirs() // 创建所有不存在的父目录
                Log.i(TAG, "创建目录: $absolutePath")
            }
        }

        // 2. 创建文件（如果不存在）
        return File(parentDir, fileName).apply {
            if (!exists()) {
                createNewFile() // 创建空文件
                Log.i(TAG, "创建文件: $absolutePath")
            }
        }
    }

    /// 开始接受位置信息
    fun startLocation() {
        var tempLatitude = 0.0;
        var tempLongitude = 0.0;
        locationCallback = object : LocationCallback() {
            override fun onLocationResult(p0: LocationResult) {
                if (tempLatitude == p0.lastLocation?.latitude && tempLongitude == p0.lastLocation?.longitude) {
                    // 如果经纬度没有发生变化则不进行存储
                    return
                }
                Log.i(
                    TAG,
                    "${p0.lastLocation?.time};${p0.lastLocation?.latitude};${p0.lastLocation?.longitude}"
                )
                tempLatitude = p0.lastLocation?.latitude ?: 0.0
                tempLongitude = p0.lastLocation?.longitude ?: 0.0
                appendToFile("${p0.lastLocation?.time};${p0.lastLocation?.latitude};${p0.lastLocation?.longitude}")
            }
        }

        try {
            fusedLocationClient.requestLocationUpdates(
                locationRequest,
                locationCallback as LocationCallback,
                Looper.getMainLooper()
            )
        } catch (e: SecurityException) {
            Log.e(TAG, e.toString())
        }
    }

    /**
     * 停止位置记录
     * @return 位置信息文件路径
     */
    fun stopLocation(): String {
        locationCallback?.let {
            fusedLocationClient.removeLocationUpdates(it)
            locationCallback = null
        }
        return createLocationFile(context, fileName).absolutePath
    }
}