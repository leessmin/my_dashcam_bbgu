package com.leessmin.my_dashcam.activity.camera.utils

import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import java.io.File
import java.nio.file.Files
import java.nio.file.Path
import kotlin.io.path.pathString
import kotlin.math.ceil


private const val TAG = "FileClean"

/**
 * 清理某个目录下的文件夹
 * @param path 目录路径
 * @param max 目录最大的空间，超过最大空间则执行清理 单位GB, 如果传入0则代表不执行清理
 * @param deleteCallback 删除的视频后的回调, 唯一参数,视频路径
 */
@RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
fun fileClean(
    path: String,
    max: Int,
    deleteDirCallback: (String) -> Unit,
    deleteCallback: (String) -> Unit
) {
    if (max == 0) return

    val mbMax = max * 1024
    val dir = File(path)
    if (getDirectorySize(dir) < mbMax) {
        return
    }

    val files =
        Files.walk(Path.of(dir.absolutePath)).map { it.toFile() }.filter { it.isFile }
            .toList()

    // 最早的文件在前面
    val fileList = files.sortedBy { it.lastModified() }

    fileList.forEach {
        if (getDirectorySize(dir) < mbMax) {
            return
        }
        Log.d(TAG, "删除文件: ${it.absolutePath}")
        deleteCallback(it.absolutePath)
        it.delete()
        deleteEmptyDirectory(Path.of(it.parent), deleteDirCallback)
    }
}

/**
 * 计算目录大小
 * @param dir 目录对象
 * @return 返回目录大小，单位MB
 */
@RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
private fun getDirectorySize(dir: File): Float {
    val size = Files.walk(Path.of(dir.absolutePath)).filter { it.toFile().isFile }
        .mapToLong { it.toFile().length() }
        .sum()
    return ceil(size / 1024F / 1024F)
}

/**
 * 删除空目录
 * @param path 要删除的目录
 * @param deleteDirCallback 删除目录后的回调
 */
private fun deleteEmptyDirectory(path: Path, deleteDirCallback: (String) -> Unit) {
    if (Files.isDirectory(path) && Files.list(path).count() == 0L) {
        Log.d(TAG, "删除目录: ${path.pathString}")
        Files.delete(path)
        // 删除目录对应的 地理位置文件
        deleteDirCallback(path.toString().substringAfterLast("/"));
    }
}