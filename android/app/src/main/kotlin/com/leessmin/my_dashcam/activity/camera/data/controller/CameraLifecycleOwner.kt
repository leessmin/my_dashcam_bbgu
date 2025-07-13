package com.leessmin.my_dashcam.activity.camera.data.controller

import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry

class CameraLifecycleOwner : LifecycleOwner {
    private val lifecycleRegistry = LifecycleRegistry(this)

    override val lifecycle: Lifecycle
        get() = lifecycleRegistry

    fun handleLifecycleEvent(event: Lifecycle.Event) {
        lifecycleRegistry.handleLifecycleEvent(event)
    }

    // 启动生命周期
    fun start() {
        handleLifecycleEvent(Lifecycle.Event.ON_START)
    }

    // 停止生命周期
    fun stop() {
        handleLifecycleEvent(Lifecycle.Event.ON_STOP)
    }

    // 销毁生命周期
    fun destroy() {
        handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        // 生命周期销毁，实例也跟着销毁
        instance = null
    }

    companion object {
        @Volatile
        private var instance: CameraLifecycleOwner? = null

        fun getInstance(): CameraLifecycleOwner {
            return instance ?: synchronized(this) {
                instance ?: CameraLifecycleOwner().also {
                    it.start()
                    instance = it
                }
            }
        }
    }
}